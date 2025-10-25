# Top level chat interaction
TThis document captures the interaction with copilot during implementation of the `./abc/take-3-note-analysis/` workflow.

# Initial prompt

Our team designed a `./abc/take-2/` workflow in Agent Builder Consoler (ABC), see support in `data-public/raw/AAAL2/abc-help.md`. It runs satisfactorily and produces  the output that we want. See `./abc/take-2/output/` folder for the artifacts our flow generates. Note that we have two data artifacts of particular note:
- `synthetic-case-notes` (csv and json), the output of the workflow
- `synthetic-case-note-for-input` (csv and json), a modified version of the `synthetic-case-notes` that preserved only the variables that would be available in a production environment (not columns that describe simulation parameters). 

Now I would like to design a new workflow in ABC, called `./abc/take-3-note-analysis/`, that ingests the `synthetic-case-note-for-input` data artifact and performs analysis of this data. We have started thinking about how to implement this analysis in `./analysis/eda-2-casenote/`, see `./analysis/eda-2-casenote/0-initial-prompt.md` for the initial prompt that we used to design this analysis (plus examine  the current state of work there).  eda-2-casenote aims to create a data science pipeline with implementation in R and Python, executed in VS Code environment supported by Github Copilot. 



