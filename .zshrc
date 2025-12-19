# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
eval "$(starship init zsh)"
alias steam-bg='nohup steam > /dev/null 2>&1 &'
# Alias to run the dotfiles backup and push script from anywhere
alias savedots='~/dotfiles/save.sh'
alias  reload='source ~/.zshrc'

# C Development Alias
run_c() {
    local file="$1"
    local base="${1%.*}"
    
    # Use clang for better errors and address sanitization
    clang -std=c17 -Wall -Wextra -Wpedantic -g -fsanitize=address "$file" -o "$base" && \
    ./"$base" && \
    rm "$base"
}
alias rc=run_c


mkcproj() {
    local proj_name=$1
    [[ -z "$proj_name" ]] && { echo "Usage: mkcproj <name>"; return 1; }

    mkdir -p "$proj_name"/{include/"$proj_name",src,tests,docs,external,build/debug,build/release}
    touch "$proj_name"/{README.md,LICENSE}
    
    # .gitignore
    echo "build/\n.cache/\n*.o\n*.so\n.DS_Store" > "$proj_name"/.gitignore

    # src/main.c
    cat <<EOF > "$proj_name"/src/main.c
#include <stdio.h>

int main(void) {
    #ifdef NDEBUG
        printf("Running in PRODUCTION mode.\n");
    #else
        printf("Running in DEBUG mode (Sanitizers active).\n");
    #endif
    return 0;
}
EOF

    # CMakeLists.txt
    cat <<EOF > "$proj_name"/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project($proj_name C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Setup Flags based on Build Type
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-Wall -Wextra -Wpedantic -g -fsanitize=address)
    add_link_options(-fsanitize=address)
else()
    add_compile_options(-O3 -march=native)
    add_definitions(-DNDEBUG)
endif()

# Core Targets
add_library(\${PROJECT_NAME}_lib INTERFACE)
target_include_directories(\${PROJECT_NAME}_lib INTERFACE include)

add_executable(\${PROJECT_NAME}_run src/main.c)
target_link_libraries(\${PROJECT_NAME}_run PRIVATE \${PROJECT_NAME}_lib)
target_include_directories(\${PROJECT_NAME}_run PRIVATE src)
EOF

    echo "✅ Project '$proj_name' initialized."
    echo "Commands: 'bdeb' for Debug, 'bprod' for Production."
    cd ./"$proj_name" }

# --- Debug Build & Run ---
bdeb() {
    local root_dir=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    mkdir -p "$root_dir/build/debug"
    pushd "$root_dir/build/debug" > /dev/null

    if [[ ! -f "build.ninja" ]]; then
        echo "󱁤 Configuring DEBUG build (ASan + C17 + Ninja)..."
        cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug ../..
    fi

    if ninja; then
        echo "🚀 Running Debug..."
        local exe=$(find . -maxdepth 1 -type f -name "*_run" | head -n 1)
        [[ -n "$exe" ]] && "$exe" || echo "❌ No executable found."
    fi
    popd > /dev/null
}

# --- Production Build & Run ---
bprod() {
    local root_dir=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    mkdir -p "$root_dir/build/release"
    pushd "$root_dir/build/release" > /dev/null

    if [[ ! -f "build.ninja" ]]; then
        echo "󱁤 Configuring PRODUCTION build (O3 Optimization + Ninja)..."
        cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ../..
    fi

    if ninja; then
        echo "🚀 Running Production..."
        local exe=$(find . -maxdepth 1 -type f -name "*_run" | head -n 1)
        [[ -n "$exe" ]] && "$exe" || echo "❌ No executable found."
    fi
    popd > /dev/null
}

