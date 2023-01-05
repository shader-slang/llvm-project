# NOTE! This is part of Slang project
# to be able to build LLVM via holy build box
# https://github.com/phusion/holy-build-box

OS=linux
PLATFORM=$1
CONFIGURATION=$2

TARGET_OPTIONS=""

if [[ "${PLATFORM}" == "x86" ]]; then
    sudo apt-get install gcc-multilib g++-multilib
    TARGET_OPTIONS="-DLLVM_BUILD_32_BITS=1"
fi
      
# LLVM build needs python3.
# We have yum, so install python3 with that.      
yum install -y python3

# We want to build with shared libraries/-fPIC
source /hbb_shlib/activate

cmake llvm -B ./build -DCMAKE_BUILD_TYPE=${CONFIGURATION} -DCMAKE_CXX_VISIBILITY_PRESET="hidden" -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD="X86;ARM" -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="AArch64" -DCLANG_BUILD_TOOLS=0 -DCLANG_ENABLE_STATIC_ANALYZER=0 -DCLANG_ENABLE_ARCMT=0 -DCLANG_INCLUDE_DOCS=0 -DCLANG_INCLUDE_TESTS=0 -DLLVM_BUILD_LLVM_C_DYLIB=0 -DLLVM_INCLUDE_BENCHMARKS=0 -DLLVM_INCLUDE_DOCS=0 -DLLVM_INCLUDE_EXAMPLES=0 -DLLVM_BUILD_TOOLS=1 -DLLVM_INCLUDE_TESTS=0 -DLLVM_ENABLE_TERMINFO=0 ${TARGET_OPTIONS}

cmake --build ./build --config ${CONFIGURATION} -j`nproc`
