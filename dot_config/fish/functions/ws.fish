function ws -d "Clone or move to a project"
	set -l repo $argv[1]

	set -l root $HOME/Projects
	if test -d /media/vault/Projects
		set root /media/vault/Projects
	end

	if test -z "$repo"
		echo "Please set a repository name."
		return 1
	end

	if not test -d $root/$repo
		mkdir -p $root/$repo
		git clone git@github.com:$argv $root/$repo
	end
	cd $root/$repo
end
