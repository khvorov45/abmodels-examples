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
rule sim:
    input:
        ".deps-installed",
        "data/sim.R"
    output:
        "data/sim-cox.csv",
        "data/sim-lr.csv",
        "data/sim-sclr.csv"
    shell:
        "Rscript data/sim.R"

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
rule fit:
    input:
        ".deps-installed",
        "model-fit/fit.R",
        "data/sim-cox.csv",
        "data/sim-lr.csv",
        "data/sim-sclr.csv"
    output:
        "model-fit/predict-cox.csv",
        "model-fit/predict-lr.csv",
        "model-fit/predict-sclr.csv"
    shell:
        "Rscript model-fit/fit.R"

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

# Rules for plotting protection curves
rule plot_prot:
    input:
        ".deps-installed",
        "protect-plot/protect-plot.R",
        "model-fit/predict-cox.csv",
        "model-fit/predict-lr.csv",
        "model-fit/predict-sclr.csv",
        "model-fit/predict-boot-lr.csv"
    output:
        "protect-plot/protect-cox.pdf",
        "protect-plot/protect-lr.pdf",
        "protect-plot/protect-sclr.pdf",
        "protect-plot/protect-boot-lr.pdf",
        "protect-plot/protect-boot-lr-rel.pdf"
    shell:
        "Rscript protect-plot/protect-plot.R"
