BRANCHES=`git branch`

for branch in $BRANCHES
  do
  if [ "master" != $branch ]
    then
      git checkout $branch
      git rebase master
      git checkout --ours .
      echo "FROM bde2020/spark-base:${branch}" > Dockerfile
      cat Dockerfile.template >> Dockerfile
      git add .

      git rebase --continue
      git push -f origin $branch
  fi
done

git checkout master
