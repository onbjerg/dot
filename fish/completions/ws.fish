function complete_existing_projects
  set prev $PWD
  cd /media/vault/Projects
  for project in */*
    echo $project
  end
  cd $prev
end
complete -x -c ws -d "Project (owner/repo)" -a "(complete_existing_projects)"
