import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { VERSION } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";
import { basename } from "node:path";

const REFRESH_INTERVAL_MS = 3000;
const FIELD_SEPARATOR = " · ";

type JjFooterState = {
	status: string;
	changeId?: string;
	bookmark?: string;
};

let jjState: JjFooterState = { status: "…" };
let refreshing = false;
let requestFooterRender: (() => void) | undefined;
let refreshTimer: NodeJS.Timeout | undefined;

function formatDir(cwd: string): string {
	return basename(cwd) || cwd;
}

function formatCost(ctx: ExtensionContext): string {
	let total = 0;
	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type === "message" && entry.message.role === "assistant") {
			total += entry.message.usage.cost.total;
		}
	}
	return `$${total.toFixed(3)}`;
}

function formatContext(ctx: ExtensionContext): string {
	const usage = ctx.getContextUsage();
	const cost = formatCost(ctx);
	if (!usage || usage.percent === null) return `ctx ? (${cost})`;
	return `ctx ${usage.percent.toFixed(1)}% (${cost})`;
}

function padBetween(left: string, right: string, width: number): string {
	const leftWidth = visibleWidth(left);
	const rightWidth = visibleWidth(right);

	if (leftWidth + 2 + rightWidth <= width) {
		return `${left}${" ".repeat(width - leftWidth - rightWidth)}${right}`;
	}

	const minGap = 2;
	const rightBudget = Math.max(0, Math.min(rightWidth, Math.floor(width * 0.45)));
	const truncatedRight = truncateToWidth(right, rightBudget, "…");
	const remaining = Math.max(0, width - visibleWidth(truncatedRight) - minGap);
	const truncatedLeft = truncateToWidth(left, remaining, "…");
	const gap = Math.max(1, width - visibleWidth(truncatedLeft) - visibleWidth(truncatedRight));
	return truncateToWidth(`${truncatedLeft}${" ".repeat(gap)}${truncatedRight}`, width, "");
}

function summarizeJjStatus(stdout: string): string {
	const text = stdout.trim();
	if (!text) return "clean";

	if (/working copy is clean/i.test(text) || /no changes/i.test(text)) {
		return "clean";
	}

	const lower = text.toLowerCase();
	const hasConflict = lower.includes("conflict");
	const changedLines = text
		.split(/\r?\n/)
		.map((line) => line.trim())
		.filter((line) => /^[MADRC?!]{1,2}\s+/.test(line));

	if (changedLines.length > 0) {
		const files = changedLines.length === 1 ? "1 file" : `${changedLines.length} files`;
		return hasConflict ? `${files}, conflicts` : files;
	}

	return hasConflict ? "conflicts" : "dirty";
}

function parseFirstLine(stdout: string): string | undefined {
	return stdout.trim().split(/\r?\n/).map((line) => line.trim()).filter(Boolean)[0];
}

async function refreshJjStatus(pi: ExtensionAPI, ctx: ExtensionContext): Promise<void> {
	if (refreshing) return;
	refreshing = true;
	try {
		const statusResult = await pi.exec("jj", ["--no-pager", "status", "--color", "never"], {
			cwd: ctx.cwd,
			timeout: 2000,
		});

		if (statusResult.code !== 0) {
			jjState = { status: "no jj" };
			return;
		}

		const changeResult = await pi.exec("jj", [
			"--no-pager",
			"log",
			"-r",
			"@",
			"--no-graph",
			"-T",
			'change_id.short(8) ++ "\\n"',
		], { cwd: ctx.cwd, timeout: 2000 });

		const bookmarkResult = await pi.exec("jj", [
			"--no-pager",
			"bookmark",
			"list",
			"-r",
			"heads(::@ & bookmarks())",
			"-T",
			'name ++ "\\n"',
		], { cwd: ctx.cwd, timeout: 2000 });

		jjState = {
			status: summarizeJjStatus(statusResult.stdout),
			changeId: changeResult.code === 0 ? parseFirstLine(changeResult.stdout) : undefined,
			bookmark: bookmarkResult.code === 0 ? parseFirstLine(bookmarkResult.stdout) : undefined,
		};
	} catch {
		jjState = { status: "no jj" };
	} finally {
		refreshing = false;
		requestFooterRender?.();
	}
}

function installFooter(pi: ExtensionAPI, ctx: ExtensionContext): void {
	if (!ctx.hasUI) return;

	if (refreshTimer) {
		clearInterval(refreshTimer);
		refreshTimer = undefined;
	}

	ctx.ui.setFooter((tui, theme) => {
		requestFooterRender = () => tui.requestRender();
		void refreshJjStatus(pi, ctx);
		refreshTimer = setInterval(() => void refreshJjStatus(pi, ctx), REFRESH_INTERVAL_MS);

		return {
			dispose() {
				if (refreshTimer) {
					clearInterval(refreshTimer);
					refreshTimer = undefined;
				}
				if (requestFooterRender) requestFooterRender = undefined;
			},
			invalidate() {},
			render(width: number): string[] {
				const dir = formatDir(ctx.cwd);
				const context = formatContext(ctx);
				const model = ctx.model?.id ?? "no-model";
				const thinking = pi.getThinkingLevel();

				const change = jjState.changeId
					? `@ ${jjState.changeId}${jjState.bookmark ? ` (${jjState.bookmark})` : ""}`
					: undefined;
				const leftParts = [
					dir,
					change,
					jjState.status,
					context,
				].filter((part): part is string => Boolean(part));
				const rightParts = [model, thinking, `v${VERSION}`];

				const left = theme.fg("dim", leftParts.join(FIELD_SEPARATOR));
				const right = theme.fg("dim", rightParts.join(FIELD_SEPARATOR));
				return [padBetween(left, right, width)];
			},
		};
	});
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		installFooter(pi, ctx);
	});

	pi.on("tool_result", (event, ctx) => {
		if (!ctx.hasUI) return;
		if (event.toolName === "edit" || event.toolName === "write" || event.toolName === "bash") {
			void refreshJjStatus(pi, ctx);
		}
	});

	pi.on("session_shutdown", () => {
		if (refreshTimer) {
			clearInterval(refreshTimer);
			refreshTimer = undefined;
		}
		requestFooterRender = undefined;
	});
}
