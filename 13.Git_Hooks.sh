#Example: Enforce code formatting standards using a shell script.
#!/bin/bash

# Check for code formatting issues using a linter
if ! lint_output=$(linter_command); then
    echo "Code formatting issues found. Please fix them before committing."
    echo "$lint_output"
    exit 1
fi
________________________________________________________________________________________

#Example: Enforce a policy that requires a commit message to include a JIRA issue number.
#!/bin/bash

while read old_rev new_rev ref_name; do
    commit_msg=$(git log --format=%B $new_rev -1)
    if ! [[ $commit_msg =~ JIRA-[0-9]+ ]]; then
        echo "Commit message must include a JIRA issue number (e.g., JIRA-123)."
        exit 1
    fi
done
________________________________________________________________________________________


#Example: Trigger a deployment to the staging server after a successful push.
#!/bin/bash

if [ $ref_name = "refs/heads/staging" ]; then
    # Trigger deployment to staging server
    ssh user@staging-server "cd /path/to/repo && git pull origin staging && ./deploy.sh"
fi

________________________________________________________________________________________

#Example: Run automated tests before pushing changes.
#!/bin/bash

# Run test suite
if ! test_output=$(./run_tests.sh); then
    echo "Tests failed. Please fix the issues before pushing."
    echo "$test_output"
    exit 1
fi

________________________________________________________________________________________

