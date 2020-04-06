
# Cox directories
COX_DIR = "cox-proportional-hazards"
COX_DATA_DIR = COX_DIR + "/data"
COX_DATA_PLOT_DIR = COX_DIR + "/data-plot"
COX_MODEL_FIT_DIR = COX_DIR + "/model-fit"
COX_MODEL_FIT_PLOT_DIR = COX_DIR + "/model-fit-plot"

# Cox files
COX_DATA_FILE = COX_DATA_DIR + "/sim-cox.csv"
COX_DATA_PLOT_FILE = COX_DATA_PLOT_DIR + "/sim-plot.pdf"
COX_MODEL_FIT_FILE = COX_MODEL_FIT_DIR + "/fit.csv"
COX_MODEL_FIT_PLOT_FILE = COX_MODEL_FIT_PLOT_DIR + "/protection.pdf"

# Cox scripts
COX_DATA_SCRIPT = COX_DATA_DIR + "/sim-cox.R"
COX_DATA_PLOT_SCRIPT = COX_DATA_PLOT_DIR + "/sim-plot.R"
COX_MODEL_FIT_SCRIPT = COX_MODEL_FIT_DIR + "/fit.R"
COX_MODEL_FIT_PLOT_SCRIPT = COX_MODEL_FIT_PLOT_DIR + "/fit-plot.R"

rule clean_cox:
    shell:
        "rm -f " + " ".join([
            COX_DATA_FILE, 
            COX_DATA_PLOT_FILE, 
            COX_MODEL_FIT_FILE,
            COX_MODEL_FIT_PLOT_FILE
        ])

rule all_cox:
    input:
        COX_MODEL_FIT_PLOT_FILE,
        COX_DATA_PLOT_FILE

rule sim_cox:
    input:
        COX_DATA_SCRIPT
    output:
        COX_DATA_FILE
    script:
        COX_DATA_SCRIPT

rule plot_cox:
    input:
        COX_DATA_FILE,
        COX_DATA_PLOT_SCRIPT
    output:
        COX_DATA_PLOT_FILE
    script:
        COX_DATA_PLOT_SCRIPT

rule fit_cox:
    input:
        COX_DATA_FILE,
        COX_MODEL_FIT_SCRIPT
    output:
        COX_MODEL_FIT_FILE
    script:
        COX_MODEL_FIT_SCRIPT

rule plot_protection_cox:
    input:
        COX_MODEL_FIT_FILE,
        COX_MODEL_FIT_PLOT_SCRIPT
    output:
        COX_MODEL_FIT_PLOT_FILE
    script:
        COX_MODEL_FIT_PLOT_SCRIPT
