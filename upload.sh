#!/bin/bash
git add .
d=$(date)
echo "Enter name: "
read -r user
git commit -m "$d-$user"
git push origin master