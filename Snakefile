# Cox directories
COX_DIR = "cox-proportional-hazards"
COX_DATA_DIR = f"{COX_DIR}/data"
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

# Logistic directories
LR_DIR = "logistic-regression"
LR_DATA_DIR = LR_DIR + "/data"
LR_DATA_PLOT_DIR = LR_DIR + "/data-plot"
LR_MODEL_FIT_DIR = LR_DIR + "/model-fit"
LR_MODEL_FIT_PLOT_DIR = LR_DIR + "/model-fit-plot"

# Logistic files
LR_DATA_FILE = LR_DATA_DIR + "/sim-lr.csv"
LR_DATA_PLOT_FILE = LR_DATA_PLOT_DIR + "/sim-plot.pdf"
LR_MODEL_FIT_FILE = LR_MODEL_FIT_DIR + "/fit.csv"
LR_MODEL_FIT_BOOT_FILE = LR_MODEL_FIT_DIR + "/fit-boot.csv"
LR_MODEL_FIT_BOOT_SUMMARY_FILE = LR_MODEL_FIT_DIR + "/fit-boot-summary.csv"
LR_MODEL_FIT_PLOT_FILES = [
    LR_MODEL_FIT_PLOT_DIR + fle for fle in
    ["/protection.pdf", "/protection-boot.pdf", "/protection-boot-rel.pdf"]
]

# Logistic scripts
LR_DATA_SCRIPT = LR_DATA_DIR + "/sim-lr.R"
LR_DATA_PLOT_SCRIPT = LR_DATA_PLOT_DIR + "/sim-plot.R"
LR_MODEL_FIT_SCRIPT = LR_MODEL_FIT_DIR + "/fit.R"
LR_MODEL_FIT_BOOT_SCRIPT = LR_MODEL_FIT_DIR + "/fit-boot.R"
LR_MODEL_FIT_BOOT_SUMMARY_SCRIPT = LR_MODEL_FIT_DIR + "/summary-boot.R"
LR_MODEL_FIT_PLOT_SCRIPT = LR_MODEL_FIT_PLOT_DIR + "/fit-plot.R"

# Rules for cleaning output
rule clean:
    shell:
        "rm -f " + " ".join([
            COX_DATA_FILE,
            COX_DATA_PLOT_FILE,
            COX_MODEL_FIT_FILE,
            COX_MODEL_FIT_PLOT_FILE,
            LR_DATA_FILE,
            LR_DATA_PLOT_FILE,
            LR_MODEL_FIT_FILE,
            LR_MODEL_FIT_BOOT_FILE,
            LR_MODEL_FIT_BOOT_SUMMARY_FILE,
            " ".join(LR_MODEL_FIT_PLOT_FILES)
        ])

rule clean_cox:
    shell:
        "rm -f " + " ".join([
            COX_DATA_FILE,
            COX_DATA_PLOT_FILE,
            COX_MODEL_FIT_FILE,
            COX_MODEL_FIT_PLOT_FILE
        ])

rule clean_lr:
    shell:
        "rm -f " + " ".join([
            LR_DATA_FILE,
            LR_DATA_PLOT_FILE,
            LR_MODEL_FIT_FILE,
            LR_MODEL_FIT_BOOT_FILE,
            LR_MODEL_FIT_BOOT_SUMMARY_FILE,
            " ".join(LR_MODEL_FIT_PLOT_FILES)
        ])

# Rules for generating all of the output
rule all:
    input:
        COX_MODEL_FIT_PLOT_FILE,
        COX_DATA_PLOT_FILE,
        LR_MODEL_FIT_PLOT_FILES,
        LR_DATA_PLOT_FILE

rule all_cox:
    input:
        COX_MODEL_FIT_PLOT_FILE,
        COX_DATA_PLOT_FILE

rule all_lr:
    input:
        LR_MODEL_FIT_PLOT_FILES,
        LR_DATA_PLOT_FILE

# Rules for simulating the data
rule sim_cox:
    input:
        COX_DATA_SCRIPT
    output:
        COX_DATA_FILE
    script:
        COX_DATA_SCRIPT

rule sim_lr:
    input:
        LR_DATA_SCRIPT
    output:
        LR_DATA_FILE
    script:
        LR_DATA_SCRIPT

# Rules for plotting the data
rule plot_cox:
    input:
        COX_DATA_FILE,
        COX_DATA_PLOT_SCRIPT
    output:
        COX_DATA_PLOT_FILE
    script:
        COX_DATA_PLOT_SCRIPT

rule plot_lr:
    input:
        LR_DATA_FILE,
        LR_DATA_PLOT_SCRIPT
    output:
        LR_DATA_PLOT_FILE
    script:
        LR_DATA_PLOT_SCRIPT

# Rules for model fitting
rule fit_cox:
    input:
        COX_DATA_FILE,
        COX_MODEL_FIT_SCRIPT
    output:
        COX_MODEL_FIT_FILE
    script:
        COX_MODEL_FIT_SCRIPT

rule fit_lr:
    input:
        LR_DATA_FILE,
        LR_MODEL_FIT_SCRIPT
    output:
        LR_MODEL_FIT_FILE
    script:
        LR_MODEL_FIT_SCRIPT

rule fit_lr_boot:
    input:
        LR_DATA_FILE,
        LR_MODEL_FIT_BOOT_SCRIPT
    output:
        LR_MODEL_FIT_BOOT_FILE
    script:
        LR_MODEL_FIT_BOOT_SCRIPT

rule summ_lr_boot:
    input:
        LR_MODEL_FIT_BOOT_FILE,
        LR_MODEL_FIT_BOOT_SUMMARY_SCRIPT
    output:
        LR_MODEL_FIT_BOOT_SUMMARY_FILE,
    script:
        LR_MODEL_FIT_BOOT_SUMMARY_SCRIPT

# Rules for plotting protection curves
rule plot_prot_cox:
    input:
        COX_MODEL_FIT_FILE,
        COX_MODEL_FIT_PLOT_SCRIPT
    output:
        COX_MODEL_FIT_PLOT_FILE
    script:
        COX_MODEL_FIT_PLOT_SCRIPT

rule plot_prot_lr:
    input:
        LR_MODEL_FIT_FILE,
        LR_MODEL_FIT_BOOT_SUMMARY_FILE,
        LR_MODEL_FIT_PLOT_SCRIPT
    output:
        LR_MODEL_FIT_PLOT_FILES
    script:
        LR_MODEL_FIT_PLOT_SCRIPT
