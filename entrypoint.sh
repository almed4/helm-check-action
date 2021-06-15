#!/bin/bash -l

function printDelimeter {
  echo "----------------------------------------------------------------------"
}

function printLargeDelimeter {
  echo -e "\n\n------------------------------------------------------------------------------------------\n\n"
}

function printStepExecutionDelimeter {
  echo "----------------------------------------"
}

function displayInfo {
  echo
  printDelimeter
  echo
  HELM_CHECK_VERSION="v2"
  HELM_CHECK_SOURCES="https://github.com/almed4/helm-check-action"
  echo "Helm-Check $HELM_CHECK_VERSION"
  echo -e "Source code: $HELM_CHECK_SOURCES"
  echo
  printDelimeter
}

function nonEmpty {
  echo -e "\n\n\n"
  echo "Running in directory /$DIRECTORY"
  if [ -d "$DIRECTORY" ] && ! [ "$(ls -A "$DIRECTORY")" ]; then
    echo "Skipped due to condition: no templates provided."
    return 1
  else
      return 0
  fi
  printDelimeter
}

function helmLint {
  echo -e "\n\n\n"
  echo -e "1. Checking charts for possible issues\n"
  i=0
  HELM_LINT_EXIT_CODE=0
  if [[ "$1" -eq 0 ]]; then
    for dir in $(find $DIRECTORY -type d -maxdepth 1); do
      if [ "$dir" != "$DIRECTORY" ] && [ "$dir" != "$DIRECTORY/packages" ] && [ -n "$dir" ]; then
        echo "helm lint $dir"
        printStepExecutionDelimeter
        helm lint "$dir"
        HELM_LINT_EXIT_CODE=$((HELM_LINT_EXIT_CODE > $? ? HELM_LINT_EXIT_CODE : $?))
        printStepExecutionDelimeter
        i=$((i+1))
      else
        printStepExecutionDelimeter
        echo "$dir skipped due to condition: no chart found."
        printStepExecutionDelimeter
      fi
    done
    if [ $HELM_LINT_EXIT_CODE -eq 0 ]; then
      echo "Result: SUCCESS"
      echo "Charts Linted: $i"
    else
      echo "Result: FAILED"
    fi
    return $HELM_LINT_EXIT_CODE
  fi
}

function helmPackage {
  printLargeDelimeter
  echo -e "2. Trying to package charts\n"
  if [[ "$1" -eq 0 ]]; then
    printStepExecutionDelimeter
    echo -e "Creating package directory"
    mkdir "$DIRECTORY"/packages
    printStepExecutionDelimeter
    i=0
    HELM_LINT_EXIT_CODE=0
    for dir in $(find $DIRECTORY -type d -maxdepth 1); do
      if [ "$dir" != "$DIRECTORY" ] && [ "$dir" != "$DIRECTORY/packages" ] && [ -n "$dir" ]; then
        echo -e "\n helm package $dir"
        helm package "$dir" --destination "$DIRECTORY/packages"
        HELM_LINT_EXIT_CODE=$((HELM_LINT_EXIT_CODE > $? ? HELM_LINT_EXIT_CODE : $?))
        printStepExecutionDelimeter
        i=$((i+1))
      else
        printStepExecutionDelimeter
        echo "$dir skipped due to condition: no chart found."
        printStepExecutionDelimeter
      fi
    done
    if [ $HELM_PACKAGE_EXIT_CODE -eq 0 ]; then
      echo "Result: SUCCESS"
      echo "Charts Packaged: $i"
      printStepExecutionDelimeter
      echo "Exporting package directory"
      echo "::set-output name=packages::$DIRECTORY/packages"
    else
      echo "Result: FAILED"
    fi
    return $HELM_PACKAGE_EXIT_CODE
  else
    echo "Skipped due to failure: Previous step has failed"
    return "$1"
  fi
  return 0
}

function totalInfo {
  printLargeDelimeter
  echo -e "3. Summary\n"
  if [[ "$1" -eq 0 ]]; then
    echo "Examination is completed; no errors found!"
    exit 0
  else
    echo "Helm actions are completed; errors found, check the log for details!"
    exit 1
  fi
}

DIRECTORY=$1

displayInfo
nonEmpty
helmLint $?
helmPackage $?
totalInfo $?
