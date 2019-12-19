#! /bin/sh
IMAGE_URL=$1
HASH=`git rev-parse --short HEAD`
mkdir pipelineruns
git fetch --depth=2 origin
git log
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
    cat $file
    kubectl apply -f $file   
  else
    echo "no pipeline-run file found"
  fi
done