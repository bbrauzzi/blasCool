$graph:
- baseCommand: collocated-stack
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.4.17
  id: clt
  inputs:
    input_reference:
      type:
        inputBinding:
          position: 1
          prefix: --input_reference
        items: Directory
        type: array
    bands:
      inputBinding:
        position: 2
        prefix: --bands
      type: string
    aoi:
      inputBinding:
        position: 3
        prefix: --aoi
      type: string?
    s_expressions:
      inputBinding:
        position: 4
        prefix: --s-expressions
      type:
      - 'null'
      - items: string
        type: array
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        APP_DOCKER_IMAGE: docker.terradue.com/scombi-do:dev0.4.17
        APP_LOGGING: https://faas.terradue.com/function/metrics-collect-on-demand-services-uat
        APP_NAME: collocated-stack
        APP_PACKAGE: app-collocated-stack.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides a multi-mission and multi-temporal image stack of co-located
    products coming from different optical and SAR sensors against a reference image.
    It performs resampling and warping of the secondary datasets and the stacking
    of each secondary with the reference.
  id: collocated-stack
  inputs:
    input_reference:
      doc: Input product reference
      label: Input product reference
      type: Directory[]
    bands:
      doc: List of comma separated bands
      label: List of comma separated bands
      type: string
    aoi:
      doc: Area of interest expressed as Well-known text
      label: Area of interest expressed as Well-known text
      type: string?
    s_expressions:
      doc: s expression defined as cbn:expression
      label: s expression defined as cbn:expression
      type: string[]?
  label: Co-located stacking
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        input_reference: input_reference
        bands: bands
        aoi: aoi
        s_expressions: s_expressions
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.4.17
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

