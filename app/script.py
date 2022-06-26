import os
import pathlib
import subprocess


def sub_variables(inline: str) -> str:
    inline = inline.replace("ENVIRON_REPLACE_N8N_USER", os.getenv("N8N_USER"))
    inline = inline.replace("ENVIRON_REPLACE_N8N_PASS", os.getenv("N8N_PASS"))
    inline = inline.replace(
        "ENVIRON_REPLACE_HOMEAWAY_WEBHOOK", os.getenv("HOMEAWAY_WEBHOOK"))

    return inline


def RunThis(cmd: list) -> None:
    cmd = " ".join(cmd)
    p = subprocess.Popen(cmd, shell=True)
    p.wait()


def main():
    src_path = pathlib.Path("/src")
    for file in src_path.rglob("*.star"):
        infile = open(file)
        outfile = open(f"/tmp/{file.name}")

        for line in infile.readline():
            outfile.write(sub_variables(line))

        app_id = file.name.split("-")[0]

        RunThis([
            "pixlet",
            "render",
            f"{str(file)}",
            "--output",
            f"/tmp/{app_id}.webp"
        ])

        RunThis([
            "pixlet",
            "push",
            "--api-token",
            f"{os.getenv('TIDBYT_API_TOKEN')}",
            f"{os.getenv('TIDBYT_DEVICE_ID')}",
            "--installation-id",
            f"{app_id}",
            "--background",
            f"/tmp/{app_id}.webp"
        ])

        RunThis([
            "rm",
            "-f",
            f"/tmp/{app_id}.webp"
        ])


if __name__ == '__main__':
    main()
