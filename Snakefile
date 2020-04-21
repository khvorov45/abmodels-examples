# Dependency install

rule deps:
    input:
        "renv.lock"
    output:
        temp(".deps-installed")
    shell:
        """Rscript -e 'renv::restore();file.create(".deps-installed")'"""

# Rules for generating all of the output
rule all:
    input:
        ".deps-installed",
        "protect-plot/protect-cox.pdf",
        "protect-plot/protect-lr.pdf",
        "protect-plot/protect-boot-lr.pdf",
        "protect-plot/protect-boot-lr-rel.pdf",
        "protect-plot/protect-sclr.pdf",
        "data-plot/plot-cox.pdf",
        "data-plot/plot-lr.pdf",
        "data-plot/plot-sclr.pdf"

# Rules for simulating the data
rule sim_cox:
    input:
        ".deps-installed",
        "data/sim-cox.R"
    output:
        "data/sim-cox.csv"
    shell:
        "Rscript data/sim-cox.R"

rule sim_lr:
    input:
        ".deps-installed",
        "data/sim-lr.R"
    output:
        "data/sim-lr.csv"
    shell:
        "Rscript data/sim-lr.R"

rule sim_sclr:
    input:
        ".deps-installed",
        "data/sim-sclr.R"
    output:
        "data/sim-sclr.csv"
    shell:
        "Rscript data/sim-sclr.R"

# Rules for plotting the data
rule plot_cox:
    input:
        ".deps-installed",
        "data/sim-cox.csv",
        "data-plot/plot-cox.R"
    output:
        "data-plot/plot-cox.pdf"
    shell:
        "Rscript data-plot/plot-cox.R"

rule plot_bin:
    input:
        ".deps-installed",
        "data/sim-lr.csv",
        "data/sim-sclr.csv",
        "data-plot/plot-bin.R"
    output:
        "data-plot/plot-lr.pdf",
        "data-plot/plot-sclr.pdf"
    shell:
        "Rscript data-plot/plot-bin.R"

# Rules for model fitting
rule fit_cox:
    input:
        ".deps-installed",
        "data/sim-cox.csv",
        "model-fit/fit-cox.R"
    output:
        "model-fit/predict-cox.csv"
    shell:
        "Rscript model-fit/fit-cox.R"

rule fit_lr:
    input:
        ".deps-installed",
        "data/sim-lr.csv",
        "model-fit/fit-lr.R"
    output:
        "model-fit/predict-lr.csv"
    shell:
        "Rscript model-fit/fit-lr.R"

rule fit_lr_boot:
    input:
        ".deps-installed",
        "data/sim-lr.csv",
        "model-fit/boot-lr.R"
    output:
        "model-fit/boot-lr.csv"
    shell:
        "Rscript model-fit/boot-lr.R"

rule summ_lr_boot:
    input:
        ".deps-installed",
        "model-fit/boot-lr.csv",
        "model-fit/boot-summ-lr.R"
    output:
        "model-fit/predict-boot-lr.csv",
    shell:
        "Rscript model-fit/boot-summ-lr.R"

rule fit_sclr:
    input:
        ".deps-installed",
        "model-fit/fit-sclr.R",
        "data/sim-sclr.csv"
    output:
        "model-fit/predict-sclr.csv"
    shell:
        "Rscript model-fit/fit-sclr.R"

# Rules for plotting protection curves
rule plot_prot_cox:
    input:
        ".deps-installed",
        "model-fit/predict-cox.csv",
        "protect-plot/protect-cox.R"
    output:
        "protect-plot/protect-cox.pdf"
    shell:
        "Rscript protect-plot/protect-cox.R"

rule plot_prot_lr:
    input:
        ".deps-installed",
        "model-fit/predict-lr.csv",
        "model-fit/predict-boot-lr.csv",
        "protect-plot/protect-lr.R"
    output:
        "protect-plot/protect-lr.pdf",
        "protect-plot/protect-boot-lr.pdf",
        "protect-plot/protect-boot-lr-rel.pdf"
    shell:
        "Rscript protect-plot/protect-lr.R"

rule plot_prot_sclr:
    input:
        ".deps-installed",
        "model-fit/predict-sclr.csv",
        "protect-plot/protect-sclr.R"
    output:
        "protect-plot/protect-sclr.pdf"
    shell:
        "Rscript protect-plot/protect-sclr.R"
