# Guidelines for Pushing Work to the Main Branch

To ensure the `main` branch remains stable and that all changes are reviewed, please follow these steps when contributing code:

## 1. Keep Your Local `main` Branch Updated

Before starting any new work, make sure your local `main` branch is up-to-date with the remote `main` branch on GitHub.

```bash
# Switch to your main branch
git checkout main

# Pull the latest changes from the remote main branch
git pull origin main
```

## 2. Create a New Feature Branch

Create a new branch from your updated `main` branch for your new feature or bug fix. Choose a descriptive name for your branch (e.g., `feature/add-user-authentication` or `fix/login-bug`).

```bash
# Create a new branch and switch to it
git checkout -b your-feature-branch-name
```

## 3. Make Your Changes and Commit

Work on your changes in this new feature branch. Commit your changes frequently with clear and concise commit messages.

```bash
# Stage your changes
git add . 
# or git add <specific-file>

# Commit your changes
git commit -m "Your descriptive commit message"
```

## 4. Push Your Feature Branch to GitHub

Once you're ready to share your changes or want to back them up, push your feature branch to the remote repository on GitHub.

```bash
git push -u origin your-feature-branch-name
```
The `-u` flag sets up your local branch to track the remote branch, so for subsequent pushes, you can just use `git push`.

## 5. Create a Pull Request (PR)

Go to your repository on GitHub. You should see a prompt to create a Pull Request from your recently pushed branch. If not, navigate to the "Pull requests" tab and click "New pull request."

-   Select your feature branch as the "compare" branch and `main` as the "base" branch.
-   Write a clear title and description for your Pull Request, explaining the changes you've made.
-   Submit the Pull Request.

## 6. Review and Merge

Once the Pull Request is created, it can be reviewed by other team members (if applicable). After the review and any necessary discussions or further changes, the Pull Request can be merged into the `main` branch by someone with merge permissions (or yourself if it's a personal project).

This is typically done via the GitHub interface.

## 7. Update Your Local `main` Branch (After PR is Merged)

After your Pull Request has been merged into `main`, you should update your local `main` branch:

```bash
# Switch to your main branch
git checkout main

# Pull the latest changes (including your merged PR)
git pull origin main
```

## Optional: Clean Up

You can delete your local feature branch if it's no longer needed:

```bash
git branch -d your-feature-branch-name
```

And the remote feature branch (usually done via GitHub after merging the PR, or):
```bash
git push origin --delete your-feature-branch-name
```

---

By following this workflow, you help keep the `main` branch clean, ensure changes are reviewed, and make collaboration easier. Direct pushes to the `main` branch are generally discouraged in collaborative projects.
