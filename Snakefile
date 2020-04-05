rule clean:
    shell:
        "rm -f cox-proportional-hazards/data/sim-cox.csv cox-proportional-hazards/data-plot/sim-plot.pdf cox-proportional-hazards/model-fit/fit.csv cox-proportional-hazards/model-fit-plot/protection.pdf"

rule sim_cox:
    input:
        "cox-proportional-hazards/data/sim.R"
    output:
        "cox-proportional-hazards/data/sim-cox.csv"
    script:
        "cox-proportional-hazards/data/sim.R"

rule plot_cox:
    input:
        "cox-proportional-hazards/data/sim-cox.csv",
        "cox-proportional-hazards/data-plot/sim-plot.R"
    output:
        "cox-proportional-hazards/data-plot/sim-plot.pdf"
    script:
        "cox-proportional-hazards/data-plot/sim-plot.R"
