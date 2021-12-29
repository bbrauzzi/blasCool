$graph:
- baseCommand: spectral-index
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.4.17
  id: clt
  inputs:
    input_reference:
      inputBinding:
        position: 1
        prefix: --input_reference
      type: Directory
    aoi:
      inputBinding:
        position: 2
        prefix: --aoi
      type: string?
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
        APP_NAME: spectral-index
        APP_PACKAGE: app-spectral-index.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service derives multiple spectral indexes from optical remote sensing
    multispectral data. Spectral indices (NDVI, NDMIR, NDWI, NDWI 2, MNDWI, NBR, and
    NDBI) are derived from a combination of multiple optical bands from calibrated
    products.
  id: spectral-index
  inputs:
    input_reference:
      doc: Calibrated optical product
      label: Calibrated optical product
      type: Directory[]
    aoi:
      doc: Area of interest expressed as Well-known text
      label: Area of interest expressed as Well-known text
      type: string?
  label: Optical Spectral Index
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
        input_reference: input_reference
        aoi: aoi
      out:
      - results
      run: '#clt'
      scatter: input_reference
      scatterMethod: dotproduct
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.4.17
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

