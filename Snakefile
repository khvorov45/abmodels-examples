# Rules for generating all of the output
rule all:
    input:
        "protect-plot/protect-cox.pdf",
        "protect-plot/protect-lr.pdf",
        "protect-plot/protect-boot-lr.pdf",
        "protect-plot/protect-boot-lr-rel.pdf",
        "data-plot/plot-cox.pdf",
        "data-plot/plot-lr.pdf"

# Rules for simulating the data
rule sim_cox:
    input:
        "data/sim-cox.R"
    output:
        "data/sim-cox.csv"
    script:
        "data/sim-cox.R"

rule sim_lr:
    input:
        "data/sim-lr.R"
    output:
        "data/sim-lr.csv"
    script:
        "data/sim-lr.R"

# Rules for plotting the data
rule plot_cox:
    input:
        "data/sim-cox.csv",
        "data-plot/plot-cox.R"
    output:
        "data-plot/plot-cox.pdf"
    script:
        "data-plot/plot-cox.R"

rule plot_lr:
    input:
        "data/sim-lr.csv",
        "data-plot/plot-lr.R"
    output:
        "data-plot/plot-lr.pdf"
    script:
        "data-plot/plot-lr.R"

# Rules for model fitting
rule fit_cox:
    input:
        "data/sim-cox.csv",
        "model-fit/fit-cox.R"
    output:
        "model-fit/predict-cox.csv"
    script:
        "model-fit/fit-cox.R"

rule fit_lr:
    input:
        "data/sim-lr.csv",
        "model-fit/fit-lr.R"
    output:
        "model-fit/predict-lr.csv"
    script:
        "model-fit/fit-lr.R"

rule fit_lr_boot:
    input:
        "data/sim-lr.csv",
        "model-fit/boot-lr.R"
    output:
        "model-fit/boot-lr.csv"
    script:
        "model-fit/boot-lr.R"

rule summ_lr_boot:
    input:
        "model-fit/boot-lr.csv",
        "model-fit/boot-summ-lr.R"
    output:
        "model-fit/predict-boot-lr.csv",
    script:
        "model-fit/boot-summ-lr.R"

# Rules for plotting protection curves
rule plot_prot_cox:
    input:
        "model-fit/predict-cox.csv",
        "protect-plot/protect-cox.R"
    output:
        "protect-plot/protect-cox.pdf"
    script:
        "protect-plot/protect-cox.R"

rule plot_prot_lr:
    input:
        "model-fit/predict-lr.csv",
        "model-fit/predict-boot-lr.csv",
        "protect-plot/protect-lr.R"
    output:
        "protect-plot/protect-lr.pdf",
        "protect-plot/protect-boot-lr.pdf",
        "protect-plot/protect-boot-lr-rel.pdf"
    script:
        "protect-plot/protect-lr.R"
