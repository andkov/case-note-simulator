I'd like to create an ABC workflow (see: https://agentbuilderconsole.com/ and help manual in `./data-public/raw/AAAL2/abc-help.md).

Let us be thinking in systems (`/data-public/raw/AAAL2/thinking-in-systems/`). 

Consult the examples in `./data-public/raw/AAAL2/AAgent Builder - Agentic Workflow Files/` to better understand how humans use ABC.

The challenge with letting the AI agent design the app is that ABC assigns each component (agent) a specific ID when it's creating within the visual intervace of ABC in the browser. So in addition to the JSON file that defines the workflow, AI agent must generate a human-facing instruction (creation-guide) of how to recreate the workflow in the ABC visual interface. The humans will be following the instructions and upload the intermidiate JSON files from ABC for inspection by the AI agent, to be evaluated agains the original JSON and the creation-guide. This process is demonstrated in `./abc/take-2/`. .

What the app will do: the top user input will include a country name. The app will return a color palette that is inspired by the flag, culture, nature, and other aspects of the country.

But first, let's refine this prompt using the `./data-public/raw/gems/RECICO-prompt-engineer.md/` approach to ensure clarity and completeness before proceeding to the ABC workflow design.

# Additional input asked by the RECICO framework:


# Refined Prompt: 

