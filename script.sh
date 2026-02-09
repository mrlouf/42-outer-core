#!/bin/bash

repos=(
  "darkly"
  "ft_malcolm"
  "ft_traceroute"
  "Inception-of-Things"
  "cloud-1"
  "ft_ping"
  "libasm"
)

# Merge each repo
for repo in "${repos[@]}"; do

  git clone "https://github.com/mrlouf/$repo.git"

  rm -rf "$repo/.git"

  echo "====== Merging $repo ======"
  
  # Add remote
  git remote add "$repo" "https://github.com/mrlouf/$repo.git"
  
  # Fetch
  git fetch "$repo"
  
  # Get the default branch (main or master)
  branch=$(git remote show "$repo" | grep 'HEAD branch' | cut -d' ' -f5)
  
  # Merge into subdirectory
  git merge -s ours --no-commit --allow-unrelated-histories "$repo/$branch"
  git read-tree --prefix="$repo/" -u "$repo/$branch"
  git commit -m "Merge $repo as subdirectory"
  
  # Remove remote
  git remote remove "$repo"
  
  echo "✅ $repo merged successfully!"
  echo ""
done

git add .

echo "🎉 All repos merged!  Pushing to GitHub..."
git push origin main