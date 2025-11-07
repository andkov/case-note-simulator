
# Logic
Every card has access to outputs of previous cards and the userPrompt.
Instructions in the most recent card (i.e. with higher id number) should supercede in authority over those with lower id number, unless specified otherwise.



# Stage 1: Population Architecture (Architects)
Card11 - Demographics Architect - Inputs user prompt  and outputs [[demographic profile]] of target population.

Card12 - Risk Factor Modeler - Inputs user prompt and demographic profile (card11) and defines [[risk factor profile]].

# Stage 2: Client Profile Assembly (Designers)
Card21 - Archetype Designer - Combines [[demographic profile]] and [[risk factor profile]]  to generate [[archetype descriptions]].

Card22 - Complexity Calibrator - Reviews [[archetype descriptions]] and finetunes the shape of complexity into [[calibrated archetypes]] to be used by the Writers.

# Stage 3: Case Note Generation (Writers)

Card31 - Primary Case Note Writer - Focusing on [[calibrated archetypes]] and mindful of all previous outputs,  generates authentic documentation that reflects real caseworker language, concerns, and observations while maintaining complete fictional status. Determines the distribution of work for the writers - writing quota- (i.e. what percent of cases requested by userPrompt should be written by each member of the writing team).

Card32 - Variation Writer - Using [[calibrated archetypes]] and mindful of all previous outputs, generates case notes that demonstrate realistic stylistic variation and human inconsistencies in documentation practices, according to the quota defined by the Primary Case Note Writer.

Card33 - Scenario Encoder - mindful of all previous output, generates case notes with specific embedded [[testing scenarios]] according to the quota defined by the Primary Case Note Writer.

# Stage 4: Scaling and Validation (Engineers)
Card41 - Data Engineer - Using all previous outputs, designs a pipeline of reproducible scripts (R or python or combination   to play on the strong parts of each language) a) to generate synthetic case notes at scale according to specified population parameters, b) validate the generated notes against predefined quality metrics, and c) export the final dataset in user-friendly formats (CSV, JSON).


# Alternative Branch - UNIFIED GNERATION

For user convenience, it may be advisable to use a simplified alternative, in which there is only one writier, encoding all components of the simulation noise (e.g. stylistic variation, scenario embedding) into a single generation step. To provide such alternative (which we hope will come handy in development) we crated the branch card30 - card 40, which stems directly from Stage 2. 