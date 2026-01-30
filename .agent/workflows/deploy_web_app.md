---
description: Deploy Flutter Web App to GitHub Pages
---

# Deploy Flutter Web App

This workflow describes the reliable process to build and deploy the Flutter web application to GitHub Pages, handling both the `docs/` folder on `main` and the specific `gh-pages` branch sync.

## 1. Build the Web Application
Current working directory: `feedback_app_flutter`

```powershell
flutter build web --release --base-href /FeedbackApp/
```

## 2. Update `docs/` Folder (Source of Truth)
We use the `docs/` folder on the `main` branch as our primary source of truth for the deployment artifact.

```powershell
// turbo
xcopy /E /I /Y "build\web" "docs"
```

## 3. Commit Changes to Main
Commit the updated build artifacts to the main branch.

```powershell
git add docs
git commit -m "Deploy: Update web build artifacts"
git push origin main
```

## 4. Deploy to `gh-pages` Branch
This is the critical step. GitHub Pages often looks at the `gh-pages` branch. We must ensure the `docs/` folder content from `main` IS the content of `gh-pages`.

### Option A: Standard Subtree Push
Try this first. It attempts to push the subtree cleanly.

```powershell
git subtree push --prefix docs origin gh-pages
```

### Option B: The "Nuclear" Option (Force Sync)
If Option A fails (e.g., "non-fast-forward", "rejected"), use this method. It manually creates a commit from the `docs` folder code and forces it onto the `gh-pages` branch. This **guarantees** the branch matches the folder.

1.  **Create a Tree Object** from the `docs` folder:
    ```powershell
    git write-tree --prefix=docs
    ```
    *(Copy the output SHA, e.g., `54320...`)*

2.  **Create a Commit** using that tree:
    ```powershell
    git commit-tree <SHA_FROM_STEP_1> -m "Force deploy docs via commit-tree"
    ```
    *(Copy the output SHA, e.g., `6c42d...`)*

3.  **Force Push** that commit to `gh-pages`:
    ```powershell
    git push origin <SHA_FROM_STEP_2>:refs/heads/gh-pages --force
    ```

## 5. verification
1.  Check [GitHub Actions](https://github.com/PXG-Arma/FeedbackApp/actions).
2.  Wait for the "pages-build-deployment" workflow to complete (green).
3.  Visit the site: [https://pxg-arma.github.io/FeedbackApp/](https://pxg-arma.github.io/FeedbackApp/).
4.  **HARD REFRESH** (Ctrl+F5) to clear browser cache.
