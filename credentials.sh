client_id=$(curl -H "Authorization: Basic ZGF5YWthci5nQGhjbC5jb206TmV2ZXI0Z3QwMSE=" "https://api.enterprise.apigee.com/v1/organizations/dayakarg-eval/apiproducts/Cicd-Product?query=list&entity=keys")

id=$(jq -r .[0] <<< "${client_id}" )
echo $id

client_secret=$(curl -H "Authorization: Basic ZGF5YWthci5nQGhjbC5jb206TmV2ZXI0Z3QwMSE=" "https://api.enterprise.apigee.com/v1/organizations/dayakarg-eval/developers/hw@api.com/apps/hwapp/keys/$id")

secret=$(jq -r .consumerSecret <<< "${client_secret}" )
echo $secret
