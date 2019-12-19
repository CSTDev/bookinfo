#! /bin/sh
IMAGE_URL=$1
BRANCH_REF=$2
BRANCH=`echo ${BRANCH_REF##*/}`
git checkout $BRANCH
git fetch --unshallow
HASH=`git rev-parse --short HEAD`
directories=`git diff --dirstat=files,0 HEAD~1 | sed 's/[0-9.]\+% //g' | uniq | sort -r`
for dir in $directories; do
  echo $dir
  if [[ $dir == *'tekton'* ]]; then
    echo "applying tekton resources"
    kubectl apply -f $dir
    continue
  fi
  SERVICE=`basename $dir`
  echo $service
  file=`find $dir -maxdepth 1 -name "pipeline-run.yaml"`
  if [ $file ]; then
    echo "got a pipeline run will deploy"
    yq w -i $file "spec.resources[1].resourceSpec.params[0].value" $IMAGE_URL/$SERVICE:$HASH
    yq w -i $file "metadata.name" $SERVICE-pipeline-run-$HASH-$RANDOM
    yq w -i $file "spec.resources[0].resourceSpec.params[0].value" $BRANCH
    cat $file
    kubectl apply -f $file   
  else
    echo "no pipeline-run file found"
  fi
done