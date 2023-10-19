import os
import sys


def get_operating_system():
    platform = sys.platform

    if platform == "darwin":
        return "MAC_OS"
    if "linux" in platform:
        return "LINUX"

    return ValueError("OS not supported")


def get_dotfiles_repo_folder():
    return os.path.split(__file__)[0]


def install_files_in_folder(dotfiles_folder, install_folder):
    install_folder = os.path.expanduser(install_folder)
    for (base, folder_names, file_names) in os.walk(dotfiles_folder):
        for folder_name in folder_names:
            source_path = os.path.realpath(os.path.join(base, folder_name))
            relative_path = os.path.relpath(source_path, start=dotfiles_folder)
            target_path = os.path.join(install_folder, relative_path)
            link_folder(source_path, target_path)

        for file_name in file_names:
            if file_name[0] == "#" or file_name[-1] == "~":
                # don't manage autosave files
                continue
            elif file_name == ".DS_Store":
                continue

            source_path = os.path.realpath(os.path.join(base, file_name))
            relative_path = os.path.relpath(source_path, start=dotfiles_folder)
            target_path = os.path.join(install_folder, relative_path)
            link_file(source_path, target_path)


def link_folder(source_path, target_path):
    os.makedirs(target_path, exist_ok=True)


def link_file(source_path, target_path):
    if os.path.exists(target_path):
        print(f"File exists at {target_path}")
        os.remove(target_path)

    os.symlink(source_path, target_path)
    print(f"Installed file from: {source_path}")
    print(f"Installed to: {target_path}\n")


def get_dotfiles_folders_to_install():
    os_name = get_operating_system()
    repo_folder = get_dotfiles_repo_folder()
    dotfiles_folders = ["all"]

    if os_name == "MAC_OS":
        dotfiles_folders.append("mac")
    elif os_name == "LINUX":
        dotfiles_folders.append("linux")
    elif os_name == "WIN32":
        dotfiles_folders.append("win32")
    elif os_name == "WIN64":
        dotfiles_folders.append("win64")
    else:
        raise ValueError("Incorrect operating system type")

    dotfiles_paths = [os.path.join(repo_folder, x) for x in dotfiles_folders]
    return dotfiles_paths


def main(install_dir):
    print(f"Installing dotfiles to {install_dir}")
    dotfiles_folders = get_dotfiles_folders_to_install()

    for dotfiles_folder in dotfiles_folders:
        install_files_in_folder(dotfiles_folder, install_dir)


if __name__ == "__main__":
    install_dir = sys.argv[1] if len(sys.argv) > 1 else "~/"
    main(install_dir)
