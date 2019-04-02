BRANCHES=`git branch`

for branch in $BRANCHES
  do
  if [ "master" != "$branch" ]
    then
      git branch -D $branch
      sh create-branch.sh $branch
  fi
done
