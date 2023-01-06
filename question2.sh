#!/bin/bash

# Check if the required number of arguments are passed
if [ $# -lt 2 ]
then
    echo "Error: Two arguments are required - branch name and file name"
    exit 1
fi

# Assign the arguments to variables
branch=$1
file=$2

# Check if the branch exists
if ! git show-ref --verify --quiet refs/heads/$branch
then
    echo "Error: The branch '$branch' does not exist"
    exit 1
fi

# Check if the file exists in the branch
if ! git ls-tree -r $branch -- "$file"
then
    echo "Error: The file '$file' does not exist in the branch '$branch'"
    exit 1
fi

# Create the log file and write the header
echo "Commit versions of '$file' in branch '$branch':" > "$branch"_"$file".log
echo >> "$branch"_"$file".log

# Get the list of commit hashes for the file in the branch
commits=$(git log --pretty=format:'%H' --follow "$file" -- $branch)

# Iterate through the list of commit hashes and get the commit message and date for each commit
i=1
while read -r commit; do
    message=$(git log -1 --pretty=format:'%s' $commit)
    date=$(git log -1 --pretty=format:'%cd' $commit)
    echo "Branch: $branch" >> "$branch"_"$file".log
    echo "Commit $i: $commit" >> "$branch"_"$file".log
    echo "Commit Message: $message" >> "$branch"_"$file".log
    echo "Date: $date" >> "$branch"_"$file".log
    echo "----------------------" >> "$branch"_"$file".log
    echo "CONTENT FILE COMMITED" >> "$branch"_"$file".log
    echo >> "$branch"_"$file".log
    echo "----------------------------" >> "$branch"_"$file".log
    i=i+1
done <<< "$commits"

#echo "Log file '$file'_'$branch'_log.txt created successfully"
