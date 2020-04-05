rule clean_cox:
    shell:
        "rm -f cox-proportional-hazards/data/sim-cox.csv cox-proportional-hazards/data-plot/sim-plot.pdf cox-proportional-hazards/model-fit/fit.csv cox-proportional-hazards/model-fit-plot/protection.pdf"

rule all_cox:
    input:
        "cox-proportional-hazards/model-fit-plot/protection.pdf",
        "cox-proportional-hazards/data-plot/sim-plot.pdf"

rule sim_cox:
    input:
        "cox-proportional-hazards/data/sim-cox.R"
    output:
        "cox-proportional-hazards/data/sim-cox.csv"
    script:
        "cox-proportional-hazards/data/sim-cox.R"

rule plot_cox:
    input:
        "cox-proportional-hazards/data/sim-cox.csv",
        "cox-proportional-hazards/data-plot/sim-plot.R"
    output:
        "cox-proportional-hazards/data-plot/sim-plot.pdf"
    script:
        "cox-proportional-hazards/data-plot/sim-plot.R"

rule fit_cox:
    input:
        "cox-proportional-hazards/data/sim-cox.csv",
        "cox-proportional-hazards/model-fit/fit.R"
    output:
        "cox-proportional-hazards/model-fit/fit.csv"
    script:
        "cox-proportional-hazards/model-fit/fit.R"

rule plot_protection_cox:
    input:
        "cox-proportional-hazards/model-fit/fit.csv",
        "cox-proportional-hazards/model-fit-plot/fit-plot.R"
    output:
        "cox-proportional-hazards/model-fit-plot/protection.pdf"
    script:
        "cox-proportional-hazards/model-fit-plot/fit-plot.R"
