# Lectures on Neuroimaging
우리나라에서 뇌영상을 공부하는 대학원생 및 연구원들에게 도움이 될만한 내용으로 구성되어 있습니다. 생각보다 많은 연구실에서 뇌영상 기반의 연구를 진행하고 있지만, 국내에서 뇌영상 데이터 분석에 대해 제대로 강의가 진행되고 있는 기관은 거의 없기에 아래의 강의가 큰 도움이 되리라 생각합니다. 이론과 실습이 모두 포함되어 있지만, 실습에 집중된 강의입니다.

## Lecture 1 - Matlab 101
MRI를 분석할 수 있는 도구는 여러가지가 있습니다. 모든 툴을 완벽하레 다를 줄 알면 좋겠지만, 분석 툴은 하나의 도구일 뿐이고 사용방법에 차이가 있긴 하지만, 그 기능적인 측면에서는 크게 차이가 없습니다. 본 강좌에서는 여러 뇌영상 분석 프로그램 중 Statistical Parametric Mapping (SPM) 을 주요 도구로 선택했습니다. SPM은 GUI 환경에서도 많은 분석을 진행할 수 있지만, Matlab script에 대한 이해가 있다면, 활용 범위가 넓어질 수 있습니다. 그러기에 첫번째 장좌로 Matlab의 기초를 다루려고 합니다.  기본적인 매틀랩 명령어들을 일힐 수 있는 내용으로 구성되어 있습니다.

## Lecture 2 - Psychotoolbox
두번째 강의는 매틀랩으로 fMRI task를 만드는 방법에 대한 강의입니다. 영국 UCL을 중심으로는 Cogent라는 프로그램으로 자극을 많이 만들고, 국내에서는 E-prime으로 자극을 많이 만들고 있습니다. 하지만, Matlab으로 자극을 만든다면, E-prime에서는 구현하기 힘든 복잡한 과제도 만들 수 있기에, Matlab 기반으로 자극을 만들 수 있는 Psychotoolbox에 대해서 공부해 보는 시간을 가져 봅시다.

## Lecture 3 - SPM
이제 드디어 SPM 을 배워보겠습니다. 우선, 분석툴을 배우기 전에 SPM의 이론적 배경에 대해 review를 하고, 다음 강좌에서 분석 툴을 다뤄보기로 하겠습니다.

## Lecture 4 - Preprocessing
SPM12를 이용한 뇌영상 데이터 전처리 방법에 대한 강의입니다. Realignment, slice-timing correction, coregistration, normalization, smoothing 등 SPM에서 제공하는 여러가지 전처리 과정을 직접 실습해 보겠습니다.

## Lecture 5 - GLM(theory)
뇌영상 연구에서 사용되는 선형회귀 모델에 대한 이론 강의입니다.
ETH Zurich에서 Andreea O. Diaconescu가 강의했던 자료 "Classical Statistical Inference" 를 그대로 활용했습니다.

## Lecture 6 - GLM 실습 (개별 데이터 분석)
선형회귀모델을 이용하여 개별 뇌영상 데이터를 분석하는 방법에 대한 강의입니다.
가장 기본적인 GLM모델부터, parametric modulation 등까지 모두 다루었습니다.

## Lecture 7 - Efficiency
fMRI task design의 optimization하는 방법과 efficiency를 계산하는 방법 및 실습을 다루고 있는 강의입니다.

## Lecture 8 - GLM 실습 (그룹 데이터 분석)
뇌영상 데이터 분석의 최종 결과는 그룹 데이터를 분석하고, 여기서 얻어진 결과를 보고하게 됩니다. 여러가지 그룹 분석을 직접 실습해 볼 예정입니다. 가령, one sample t-test, paired sample t-test, full factorial, flexible factorial 분석을 모두 실습해 보겠습니다.

## Lecture 9 - 뇌영상 분석에서의 다중비교 보정
그룹 데이터 분석의 결과 중에서 어떤 것이 유의미한 결과인지? multiple comparison correction은 무엇이고 어떻게 할 수 있는지?에 대해서 이론적인 개념과 실습을 병행하여 진행할 것입니다. 

## Lecture 10 - Posthoc analysis
그룹 분석에서 유의한 차이를 보이는 영역의 beta 값을 추출하는 방법에 대해 실습합니다. 실습은 MarsBaR를 이용할 예정입니다. MarsBaR를 통해 추출한 beta 값은 추후에 correlation 분석이나, interaction 결과의 사후 통계 분석을 하는데 이용할 수 있습니다. 

## Lecture 11 - Psychophysiological interaction (PPI)
task fMRI 데이터에서 functional connectivity 분석을 하는 방법을 다룹니다. 이론적인 부분과 실습을 모두 병행할 예정입니다. 이번 실습에서는 standard PPI만 다룰 예정이지만, 이를 확장하면 generalized PPI 분석까지 할 수 있을 것입니다.