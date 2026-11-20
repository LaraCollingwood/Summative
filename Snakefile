

rule setup:
    "create all directories"
    shell:
        """
        mkdir -p data/raw
        mkdir -p data/clean
        mkdir -p results
        """


rule clean_partial:
    "Remove all files except raw data"
    shell: 
        """
        if [ -d data/clean ]; then
        rm -r data/clean
        else
        echo directory data/clean does not exist
        fi

        if [ -d results ]; then
        rm -r results
        else
        echo directory results does not exist
        fi
        """

rule clean_full:
    "Remove all files, including raw data"
    shell: 
        """
        if [ -d data/raw ]; then
        rm -r data/raw
        else
        echo directory data/raw does not exist
        fi

        if [ -d data/clean ]; then
        rm -r data/clean
        else
        echo directory data/clean does not exist
        fi

        if [ -d results ]; then
        rm -r results
        else
        echo directory results does not exist
        fi
        """