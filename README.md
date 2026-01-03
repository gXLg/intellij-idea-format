# intellij-idea-format
Check code formatting using IntelliJ IDEA in GitHub Actions

# Usage:
```
- name: Checkout repository
  uses: actions/checkout@v5
  with:
    ref: ${{ github.head_ref }}
    fetch-depth: 0
    submodules: true

- name: Setup Java
  uses: actions/setup-java@v4.0.0
  with:
    distribution: "temurin"
    java-version: 21

- name: Cache IntelliJ IDEA
  uses: actions/cache@v5
  with:
    path: .idea-cache
    key: idea-cache-2025.3.0

- name: Format with IntelliJ IDEA
  uses: gXLg/intellij-idea-format@<SHA1 reference>
  with:
    idea-url: "https://download.jetbrains.com/idea/idea-2025.3.tar.gz"
```

Export style to `project/style/IntelliJ_IDEA.xml`
