$graph:
- class: CommandLineTool 
  baseCommand: bash
  arguments:
  - "-c"
  - "exit 33"
  hints:
    DockerRequirement:
      dockerPull: docker.io/library/bash:5
  id: clt
  inputs:
    input_1:
      type: string
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory



- class: Workflow
  id: fail-app
  inputs:
    input_1:
      type: string[]
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type:
      items: Directory
      type: array
  requirements:
  - class: ScatterFeatureRequirement
  steps:
    step_1:
      in:
        input_1: input_1
      out:
      - results
      run: '#clt'
      scatter: input_1
      scatterMethod: dotproduct
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.9.4
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf
