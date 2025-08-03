# Ansible Project Structure Rules

## Symlink Directory Structure

- The `src/roles/roles/` directory is a symlink to `src/roles/`
- This is intentional and correct for Ansible project organization
- Do not treat this as a duplicate or nested directory issue
- When analyzing the project structure, recognize that `src/roles/` and `src/roles/roles/` point to the same location
- Focus on the actual role implementations in `src/roles/` directory

## Role Organization

- All Ansible roles are located in `src/roles/`
- The symlink structure is used to maintain proper Ansible conventions
- When checking for missing roles, only look in `src/roles/` directory
- Ignore the apparent "nested" structure as it's just a symlink

## File Analysis Context

- When analyzing missing components, focus on the actual file structure in `src/roles/`
- The symlink structure is not an issue that needs to be fixed
- This is a standard pattern in Ansible projects for role organization

## Project Structure Understanding

- The project uses standard Ansible conventions with roles in `src/roles/`
- The symlink pattern is intentional and should not be flagged as an issue
- When providing analysis or suggestions, base them on the actual directory structure, not the symlink appearance
