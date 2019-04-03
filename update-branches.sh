BRANCHES=`git branch | grep -v master`

for branch in $BRANCHES
  do
    git branch -D $branch
    sh create-branch.sh $branch
done
