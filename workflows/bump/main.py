from glob import glob

def main():
    for item in glob('src/*/devcontainer-feature.json'):
        print(item)

if __name__ == "__main__":
    main()
