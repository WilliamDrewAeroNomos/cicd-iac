#!/bin/bash

#echo Script name: $0

if [ "$#" -ne 3 ]; then
  echo "Error: Incorrect number of parameters."
  echo "The following parameters are required:"
  echo "Arg #1 - minikube profile (i.e. - default)"
  echo "Arg #2 - domain name (i.e. - test)"
  echo "Arg #3 - timeout value in secs"
  echo "Example: > build-resolver.sh default test 10"
  exit 2
fi

resolver_file_name="minikube-"$1"-"$2""
echo "Creating resolver file "$resolver_file_name" "

echo "domain "$2"" | tee $resolver_file_name
address=$(minikube ip)
echo "nameserver "$address"" | tee -a $resolver_file_name
echo "search_order 1" | tee -a $resolver_file_name
echo "timeout $3" | tee -a $resolver_file_name
