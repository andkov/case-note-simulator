Please let's refine the following prompt using the `./data-public/raw/gems/RECICO-prompt-engineer.md/` approach to ensure clarity and completeness before proceeding to the ABC workflow design.

I'd like to create an ABC workflow (see: https://agentbuilderconsole.com/ and help manual in `./data-public/raw/AAAL2/abc-help.md).The workflow will ingest the input from the user that include a country name and return a color palette that is inspired by the flag, culture, nature, and other aspects of the country using http://colormind.io/api-access/ to generate the color palette.

Consult the examples in `./data-public/raw/AAAL2/AAgent Builder - Agentic Workflow Files/` to better understand how humans use ABC.

The challenge with letting you design the app is that ABC assigns each component (agent) a specific ID when it's creating within the visual intervace of ABC in the browser. So in addition to the JSON file (workflow-draft-0) that defines the workflow , AI agent must generate a human-facing instruction (creation-guide) of how to recreate the workflow in the ABC visual interface. We know that workflow-draft-0 will not open or run in ABC app. To create an operable app, the human must create it themself in the browser environment of the app. So to assist the human in implementing the vision created by the AI (workflow-draft-0) you will compose this creation-guide, so that human user can create workflow-draft-1.  The humans will be following the instructions and uploading the intermidiate JSON files created in ABC for inspection by the AI, to be evaluated against workflow-draft-1 and the creation-guide. 

This process (AI drafts in VSC, humann implements in ABC) has been done accomplished before. Study `./abc/take-2/` folder to inform yourself of the process and what worked and what did not.

Follow the language and concepts described in (`/data-public/raw/AAAL2/thinking-in-systems/`).



# Additional input asked by the RECICO framework:


# Refined Prompt: 

