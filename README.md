# Let's Go Debugging!

<details>
<summary>1. Intro to Problem</summary>

* Spike: Luminate Probe VM -> Single Instance VMSS (ASG)
* 2 Orchestration types: Uniform & Flexible - separate TF resources
* Flexible best fit for needs
* Bug with TF provider
    * Worked with block for marketplace images
    * Failed when specifying our own images
* GitHub issue open for 6 months!

</details>

<details>
<summary>2. Setting up for Debugging</summary>

1. Install Go
1. Install Delve debugger
    * Linux/WSL: `go install github.com/go-delve/delve/cmd/dlv@latest`
    * Mac: `brew install delve`
1. Get Provider Source Code & Compile
    * `go build -gcflags="all=-N -l"`
        * -N disables optimisations
        * -l (lower case L) disables inlining
        * Can take a few mins
1. Create a Debug Config
    * launch.json
        * specify port for consistency/ease of use
        * 'attach' to running process
        * 'remotePath' location of executable
1. Ensure Env Vars are Present
    * `export GOPATH=$HOME/go`
    * `export PATH=$PATH:$GOPATH/bin`
1. Launch the Debugger
    * `dlv exec --listen=127.0.0.1:36283 --api-version=2 --headless ./terraform-provider-azurerm -- -debuggable`
1. Connect to the Debugger
    * VSCode Run & Debug Pane - hit play icon
1. Tell TF to use Local Provider
    * Copy & Paste TF_REATTACH_PROVIDERS output as a new env var (`export`) from above
    * Don't forget to `unset` this env var when done

</details>

<details>
<summary>3. Demo Time</summary>

* Prey to the Demo Gods

</details>

<details>
<summary>4. Other Reasons to Learn Go</summary>

* Terraform, Docker, Kubernetes all written in Go
* Great modern standard library
* Simple to use concurrency with Go Routines
* Easy cross-compiling
* Produces single binaries

</details>

<details>
<summary>5. Resources</summary>

* Go Learning Resources
    * [Udemy: Go - The Complete Developers Guide](https://www.udemy.com/course/go-the-complete-developers-guide/)
    * [Exercism: Small Concept Based Exercises](https://exercism.org/)
    * [Gophercises: Build Working Programs](https://gophercises.com/)
* My Blog Entries
    * [Setting up for Debugging](https://nathanfisk.co.uk/posts/debugging-azurerm-terraform-provider/)
    * [AzureRM Debug Walkthrough](https://nathanfisk.co.uk/posts/azurerm-terraform-provider-debugging-deepdive/)
* GitHub
    * [My Write-Up on Issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/14820#issuecomment-1197993877)

</details>