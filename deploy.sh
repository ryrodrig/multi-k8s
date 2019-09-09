# create multiple tags 
# 1. latest tag for a new person coming in he has the right version to work with
# 2. $SHA - SHA is env variable declared in .travis.yml. this is the SHA version of GIT when a code is committed.
docker build -t rodrr301/multi-client:latest -t rodrr301/multi-client:$SHA ./client
docker build -t rodrr301/multi-server:latest -t rodrr301/multi-server:$SHA ./server
docker build -t rodrr301/multi-worker:latest -t rodrr301/multi-worker:$SHA ./worker

# push latest to github.
docker push rodrr301/multi-client:latest
docker push rodrr301/multi-server:latest
docker push rodrr301/multi-worker:latest

# push sha version to github.
docker push rodrr301/multi-client:$SHA
docker push rodrr301/multi-server:$SHA
docker push rodrr301/multi-worker:$SHA

# apply k8 configs from k8s folder
kubectl apply -f k8s

# deploy the image to kubernetes with an imperative command.
# importnat thing to note is to have a new version every single time we do a deployment 
# if new version is not provided we K8s will always assume there is no change and hence not deploy
kubectl set image deployments/server-deployment server=rodrr301/multi-server:$SHA
kubectl set image deployments/client-deployment client=rodrr301/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rodrr301/multi-worker:$SHA