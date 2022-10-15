function ws
	set -l repo $argv[1]
	set -l hub $argv[2]

	if test -z "$repo"
		echo "Please set a repository name."
		return 1
	end

	if not test -d $HOME/Projects/$repo
		mkdir -p $HOME/Projects/$repo
		git clone git@github.com:$argv $HOME/Projects/$repo
	end
	cd $HOME/Projects/$repo
end
