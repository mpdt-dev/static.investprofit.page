# Changing to repository root directory
cd $(dirname $0)

for file in $(find . -name "*.zip"); do
    unzip "$file"  # Unzip the file
    rm "$file"     # Delete the file after unzipping
done

# Moving files to their respective folders
find . -name "*.jpg" -not -path "*/images/coins/*" -exec mv {} ./images/coins/ \;
find . -name "*.pdf" -not -path "*/pdf/folder/*" -exec mv {} ./pdf/folder/ \;

# Adding files to git
git add *.jpg *.pdf

# Exit if no files were added
if [ -z "$(git diff --cached --name-only | grep --no-messages --extended-regexp "\.pdf|\.jpg")" ]; then
    echo "No changes detected."
    exit 0
fi

# Commiting changes
git commit --message "" --allow-empty-message

# Displaying disk usage
du --human-readable --summarize .
du --human-readable --summarize ./images
du --human-readable --summarize ./pdf

# Pushing changes
read -p "Do you want to push changes to the repository? (y/N) " should_push
if [ "$should_push" = "y" ]; then
    git push
fi
