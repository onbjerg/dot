function ws
	set -l repo $argv[1]
	set -l hub $argv[2]
	set -q argv[2]; or set -l hub "github"

	if test -z "$repo"
		echo "Please set a repository name."
		return 1
	end

	switch $argv[2]
		case bjerger
			set hub bjerger
			set hub_host git.bjerger.xyz
		case '*'
			set hub github
			set hub_host github.com
	end

	if not test -d $HOME/Projects/$hub/$repo
		mkdir -p $HOME/Projects/$hub/$repo
		git clone git@$hub_host:$argv $HOME/Projects/$hub/$repo
	end
	cd $HOME/Projects/$hub/$repo
end
