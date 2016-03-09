#!/bin/sh
#Created by Andy S. Martin
#Operates under an MIT License
#Use at your own risk
#Please provide attribution

#Ensure that your branches are up to date
git fetch

#List out the flow of the merges
array=("branch1.0" "branch2.0" "develop" "master")

#Properly merge the most base branch
#This is the branch you should be in
#When you are updating this script
git checkout ${array[0]}
git pull origin ${array[0]}
git mergetool
git commit -am "backmerge orign ${array[0]}"
read -r -p "Push to origin? [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    git push origin ${array[0]}
else
    exit
fi

#Start with 0 and go until the last branch
index=0
count=`expr ${#array[@]} - 1`

#Merge the upper branch into the lower branch
while [ $index -lt $count ]
do
	upperBranch=${array[$index]}
	lowerBranch=${array[`expr $index + 1`]}
	echo "$upperBranch flowing into $lowerBranch"
	
	#ensure branch is current with origin
	git checkout $lowerBranch
	git pull origin $lowerBranch
	git mergetool
	
	#merge in the upper branch
	git pull origin $upperBranch
	git mergetool
	git commit -am "backmerge $upperBranch"
	read -r -p "Push to origin? [y/n] " response
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
		git push origin $lowerBranch
	else
	    exit
    fi
	
	index=`expr $index + 1`
done

git status
read -r -p "Run git clean -f ? [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	git clean -f
else
    exit
fi
