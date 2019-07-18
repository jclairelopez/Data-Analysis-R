#Install stable version
install.packages("kableExtra")
devtools::install_github("haozhu233/kableExtra")
library(knitr)
library(kableExtra)
library(RNHANES)
library(rockchalk)
library(epitools)
library(tidyverse)
library(dplyr)
library(nhanesA)
library(survey)
library(lmtest)

#Downloading the NHANES 2011-2012 datasets
final_data_a = nhanes_load_data("OHXPER_G", "2011-2012", demographics = F)
final_data_b = nhanes_load_data("DIQ_G", "2011-2012", demographics = F)
final_data_c = nhanes_load_data("OHQ_G", "2011-2012", demographics = F)
final_data_d = nhanes_load_data("SXQ_G", "2011-2012", demographics = F)
final_data_z = nhanes_load_data("DEMO_G", "2011-2012")

#Merging the 4 datasets
Data=Reduce(function(x, y) merge(x, y, all=TRUE, by.x="SEQN", by.y="SEQN"), 
            list(final_data_a, final_data_b, final_data_c, final_data_d, final_data_z))


#Variables RIAGENDR RIDAGEYR DMDEDUC2(edu level 20+) DMDMARTL(marital status) INDHHIN2(household income)
#Variables SXQ803(oral sex on woman) SXQ703(oral sex on man)
#Variables OHQ030(last time visited dentist) OHQ870(Dental Floss) OHQ875(Mouthwash)
#Variables DIQ010(diabetes)
#Variables teeth
# Upper right 2nd molar (UR2Molar)
# OHX02CJD, OHX02CJM, OHX02CJS, OHX02CJP, OHX02CJL, OHX02CJA, OHX02PCD, OHX02PCM, OHX02PCS, OHX02PCP, OHX02PCL, OHX02PCA, OHX02LAD, OHX02LAM, OHX02LAS, OHX02LAP, OHX02LAL, OHX02LAA
# Upper right 1st molar (UR1Molar)
# OHX03CJD, OHX03CJM, OHX03CJS, OHX03CJP, OHX03CJL, OHX03CJA, OHX03PCD, OHX03PCM, OHX03PCS, OHX03PCP, OHX03PCL, OHX03PCA, OHX03LAD, OHX03LAM, OHX03LAS, OHX03LAP, OHX03LAL, OHX03LAA
# Upper right 2nd bicuspid (UR2Bicuspid)
# OHX04CJD, OHX04CJM, OHX04CJS, OHX04CJP, OHX04CJL, OHX04CJA, OHX04PCD, OHX04PCM, OHX04PCS, OHX04PCP, OHX04PCL, OHX04PCA, OHX04LAD, OHX04LAM, OHX04LAS, OHX04LAP, OHX04LAL, OHX04LAA
# Upper right 1st bicuspid (UR1Bicuspid)
# OHX05CJD, OHX05CJM, OHX05CJS, OHX05CJP, OHX05CJL, OHX05CJA, OHX05PCD, OHX05PCM, OHX05PCS, OHX05PCP, OHX05PCL, OHX05PCA, OHX05LAD, OHX05LAM, OHX05LAS, OHX05LAP, OHX05LAL, OHX05LAA
# Upper right cuspid (URCuspid)
# OHX06CJD, OHX06CJM, OHX06CJS, OHX06CJP, OHX06CJL, OHX06CJA, OHX06PCD, OHX06PCM, OHX06PCS, OHX06PCP, OHX06PCL, OHX06PCA, OHX06LAD, OHX06LAM, OHX06LAS, OHX06LAP, OHX06LAL, OHX06LAA
# Upper right lateral incisor (URLIncisor)
# OHX07CJD, OHX07CJM, OHX07CJS, OHX07CJP, OHX07CJL, OHX07CJA, OHX07PCD, OHX07PCM, OHX07PCS, OHX07PCP, OHX07PCL, OHX07PCA, OHX07LAD, OHX07LAM, OHX07LAS, OHX07LAP, OHX07LAL, OHX07LAA
# Upper right central incisor (URCIncisor)
# OHX08CJD, OHX08CJM, OHX08CJS, OHX08CJP, OHX08CJL, OHX08CJA, OHX08PCD, OHX08PCM, OHX08PCS, OHX08PCP, OHX08PCL, OHX08PCA, OHX08LAD, OHX08LAM, OHX08LAS, OHX08LAP, OHX08LAL, OHX08LAA
# Upper left central incisor (ULCIncisor)
# OHX09CJD, OHX09CJM, OHX09CJS, OHX09CJP, OHX09CJL, OHX09CJA, OHX09PCD, OHX09PCM, OHX09PCS, OHX09PCP, OHX09PCL, OHX09PCA, OHX09LAD, OHX09LAM, OHX09LAS, OHX09LAP, OHX09LAL, OHX09LAA
# Upper left lateral incisor (ULLIncisor)
# OHX10CJD, OHX10CJM, OHX10CJS, OHX10CJP, OHX10CJL, OHX10CJA, OHX10PCD, OHX10PCM, OHX10PCS, OHX10PCP, OHX10PCL, OHX10PCA, OHX10LAD, OHX010LAM, OHX10LAS, OHX10LAP, OHX10LAL, OHX10LAA
# Upper left cuspid (ULCuspid)
# OHX11CJD, OHX11CJM, OHX11CJS, OHX11CJP, OHX11CJL, OHX11CJA, OHX11PCD, OHX11PCM, OHX11PCS, OHX11PCP, OHX11PCL, OHX11PCA, OHX11LAD, OHX11LAM, OHX11LAS, OHX11LAP, OHX11LAL, OHX11LAA
# Upper left 1st bicuspid/1st primary molar (UL1Bicuspid)
# OHX12CJD, OHX12CJM, OHX12CJS, OHX12CJP, OHX12CJL, OHX12CJA, OHX12PCD, OHX12PCM, OHX12PCS, OHX12PCP, OHX12PCL, OHX12PCA, OHX12LAD, OHX12LAM, OHX12LAS, OHX12LAP, OHX12LAL, OHX12LAA
# Upper left 2nd bicuspid/2nd primary molar (UL2Bicuspid)
# OHX13CJD, OHX13CJM, OHX13CJS, OHX13CJP, OHX13CJL, OHX13CJA, OHX13PCD, OHX13PCM, OHX13PCS, OHX13PCP, OHX13PCL, OHX13PCA, OHX13LAD, OHX13LAM, OHX13LAS, OHX13LAP, OHX13LAL, OHX13LAA
# Upper left 1st molar (UL1Molar)
# OHX14CJD, OHX14CJM, OHX14CJS, OHX14CJP, OHX14CJL, OHX14CJA, OHX14PCD, OHX14PCM, OHX14PCS, OHX14PCP, OHX14PCL, OHX14PCA, OHX14LAD, OHX14LAM, OHX14LAS, OHX14LAP, OHX14LAL, OHX14LAA
# Upper left 2nd molar (UL2Molar)
# OHX15CJD, OHX15CJM, OHX15CJS, OHX15CJP, OHX15CJL, OHX15CJA, OHX15PCD, OHX15PCM, OHX15PCS, OHX15PCP, OHX15PCL, OHX15PCA, OHX15LAD, OHX15LAM, OHX15LAS, OHX15LAP, OHX15LAL, OHX15LAA
# Lower left 2nd molar (LL2Molar)
# OHX18CJD, OHX18CJM, OHX18CJS, OHX18CJP, OHX18CJL, OHX18CJA, OHX18PCD, OHX18PCM, OHX18PCS, OHX18PCP, OHX18PCL, OHX18PCA, OHX18LAD, OHX18LAM, OHX18LAS, OHX18LAP, OHX18LAL, OHX18LAA
# Lower left 1st molar (LL1Molar)
# OHX19CJD, OHX19CJM, OHX19CJS, OHX19CJP, OHX19CJL, OHX19CJA, OHX19PCD, OHX19PCM, OHX19PCS, OHX19PCP, OHX19PCL, OHX19PCA, OHX19LAD, OHX19LAM, OHX19LAS, OHX19LAP, OHX19LAL, OHX19LAA
# Lower left 2nd bicuspid/2nd primary molar (LL2Bicuspid)
# OHX20CJD, OHX020JM, OHX20CJS, OHX20CJP, OHX20CJL, OHX20CJA, OHX20PCD, OHX20PCM, OHX20PCS, OHX20PCP, OHX20PCL, OHX20PCA, OHX20LAD, OHX20LAM, OHX20LAS, OHX20LAP, OHX20LAL, OHX20LAA
# Lower left 1st bicuspid/1st primary molar (LL1Bicuspid)
# OHX21CJD, OHX21CJM, OHX21CJS, OHX21CJP, OHX21CJL, OHX21CJA, OHX21PCD, OHX21PCM, OHX21PCS, OHX21PCP, OHX21PCL, OHX21PCA, OHX21LAD, OHX21LAM, OHX21LAS, OHX21LAP, OHX21LAL, OHX21LAA
# Lower left cuspid (LLCuspid)
# OHX22CJD, OHX22CJM, OHX22CJS, OHX22CJP, OHX22CJL, OHX22CJA, OHX22PCD, OHX22PCM, OHX22PCS, OHX22PCP, OHX22PCL, OHX22PCA, OHX22LAD, OHX22LAM, OHX22LAS, OHX22LAP, OHX22LAL, OHX22LAA
# Lower left lateral incisor (LLLInciscor)
# OHX23CJD, OHX23CJM, OHX23CJS, OHX23CJP, OHX23CJL, OHX23CJA, OHX23PCD, OHX23PCM, OHX23PCS, OHX23PCP, OHX23PCL, OHX23PCA, OHX23LAD, OHX23LAM, OHX23LAS, OHX23LAP, OHX23LAL, OHX23LAA
#  Lower left central incisor (LLCIncisor)
# OHX24CJD, OHX24CJM, OHX24CJS, OHX24CJP, OHX24CJL, OHX24CJA, OHX24PCD, OHX24PCM, OHX24PCS, OHX24PCP, OHX24PCL, OHX24PCA, OHX24LAD, OHX24LAM, OHX24LAS, OHX24LAP, OHX24LAL, OHX25LAA
# Lower right central incisor (LRCIncisor)
# OHX25CJD, OHX25CJM, OHX25CJS, OHX25CJP, OHX25CJL, OHX25CJA, OHX25PCD, OHX25PCM, OHX25PCS, OHX25PCP, OHX25PCL, OHX25PCA, OHX25LAD, OHX25LAM, OHX25LAS, OHX25LAP, OHX25LAL, OHX25LAA
# Lower right lateral incisor (LRLIncisor)
# OHX26CJD, OHX26CJM, OHX26CJS, OHX26CJP, OHX26CJL, OHX26CJA, OHX26PCD, OHX26PCM, OHX26PCS, OHX26PCP, OHX26PCL, OHX26PCA, OHX26LAD, OHX26LAM, OHX26LAS, OHX26LAP, OHX26LAL, OHX26LAA
# Lower right cuspid (LRCuspid)
# OHX27CJD, OHX27CJM, OHX27CJS, OHX27CJP, OHX27CJL, OHX27CJA, OHX27PCD, OHX27PCM, OHX27PCS, OHX27PCP, OHX27PCL, OHX27PCA, OHX27LAD, OHX27LAM, OHX27LAS, OHX27LAP, OHX27LAL, OHX27LAA
# Lower right 1st bicuspid/1st primary molar  (LR1Bicuspid)
# OHX28CJD, OHX28CJM, OHX28CJS, OHX28CJP, OHX28CJL, OHX28CJA, OHX28PCD, OHX28PCM, OHX28PCS, OHX28PCP, OHX28PCL, OHX28PCA, OHX28LAD, OHX28LAM, OHX28LAS, OHX28LAP, OHX28LAL, OHX28LAA
# Lower right 2nd bicuspid/2nd primary molar (LR2Bicuspid)
# OHX29CJD, OHX29CJM, OHX29CJS, OHX29CJP, OHX29CJL, OHX29CJA, OHX29PCD, OHX29PCM, OHX29PCS, OHX29PCP, OHX29PCL, OHX29PCA, OHX29LAD, OHX29LAM, OHX29LAS, OHX29LAP, OHX29LAL, OHX29LAA
# Lower right 1st molar (LR1Molar)
# OHX30CJD, OHX30CJM, OHX30CJS, OHX30CJP, OHX30CJL, OHX30CJA, OHX30PCD, OHX30PCM, OHX30PCS, OHX30PCP, OHX30PCL, OHX30PCA, OHX30LAD, OHX30LAM, OHX30LAS, OHX30LAP, OHX30LAL, OHX030LAA
# Lower right 2nd molar (LR2Molar)
# OHX31CJD, OHX31CJM, OHX31CJS, OHX31CJP, OHX31CJL, OHX31CJA, OHX31PCD, OHX31PCM, OHX31PCS, OHX31PCP, OHX31PCL, OHX31PCA, OHX31LAD, OHX31LAM, OHX31LAS, OHX31LAP, OHX31LAL, OHX31LAA

#Subsetting final dataframe by PeriStat, if the periodontal status is missing then delete
ProjData = subset(Data, OHDPDSTS != "<NA>")
#How can we make sure the missing pocket depth variables are also accounted for?
#To account for them, do we want to also subset the missing pocket depth measurements?

#Clearing Data
rm(Data)

#Selecting Variables to Keep (still missing pocket depth variabls for each tooth)
ProjData = ProjData %>% select(WTINT2YR, WTMEC2YR, RIAGENDR, RIDAGEYR, DMDEDUC2, DMDMARTL, 
                               INDHHIN2, SXQ803, SXQ703, OHQ030, OHQ870, OHQ875, DIQ010, OHDPDSTS, SDMVPSU, SDMVSTRA, WTMEC2YR,
                               OHX02PCD, OHX02PCM, OHX02PCS, OHX02PCP, OHX02PCL, OHX02PCA,
                               OHX03PCD, OHX03PCM, OHX03PCS, OHX03PCP, OHX03PCL, OHX03PCA,
                               OHX04PCD, OHX04PCM, OHX04PCS, OHX04PCP, OHX04PCL, OHX04PCA,
                               OHX05PCD, OHX05PCM, OHX05PCS, OHX05PCP, OHX05PCL, OHX05PCA,
                               OHX06PCD, OHX06PCM, OHX06PCS, OHX06PCP, OHX06PCL, OHX06PCA,
                               OHX07PCD, OHX07PCM, OHX07PCS, OHX07PCP, OHX07PCL, OHX07PCA,
                               OHX08PCD, OHX08PCM, OHX08PCS, OHX08PCP, OHX08PCL, OHX08PCA, 
                               OHX09PCD, OHX09PCM, OHX09PCS, OHX09PCP, OHX09PCL, OHX09PCA,
                               OHX10PCD, OHX10PCM, OHX10PCS, OHX10PCP, OHX10PCL, OHX10PCA,
                               OHX11PCD, OHX11PCM, OHX11PCS, OHX11PCP, OHX11PCL, OHX11PCA, 
                               OHX12PCD, OHX12PCM, OHX12PCS, OHX12PCP, OHX12PCL, OHX12PCA, 
                               OHX13PCD, OHX13PCM, OHX13PCS, OHX13PCP, OHX13PCL, OHX13PCA, 
                               OHX14PCD, OHX14PCM, OHX14PCS, OHX14PCP, OHX14PCL, OHX14PCA,
                               OHX15PCD, OHX15PCM, OHX15PCS, OHX15PCP, OHX15PCL, OHX15PCA, 
                               OHX18PCD, OHX18PCM, OHX18PCS, OHX18PCP, OHX18PCL, OHX18PCA, 
                               OHX19PCD, OHX19PCM, OHX19PCS, OHX19PCP, OHX19PCL, OHX19PCA,
                               OHX20PCD, OHX20PCM, OHX20PCS, OHX20PCP, OHX20PCL, OHX20PCA, 
                               OHX21PCD, OHX21PCM, OHX21PCS, OHX21PCP, OHX21PCL, OHX21PCA,
                               OHX22PCD, OHX22PCM, OHX22PCS, OHX22PCP, OHX22PCL, OHX22PCA,
                               OHX23PCD, OHX23PCM, OHX23PCS, OHX23PCP, OHX23PCL, OHX23PCA, 
                               OHX24PCD, OHX24PCM, OHX24PCS, OHX24PCP, OHX24PCL, OHX24PCA, 
                               OHX25PCD, OHX25PCM, OHX25PCS, OHX25PCP, OHX25PCL, OHX25PCA, 
                               OHX26PCD, OHX26PCM, OHX26PCS, OHX26PCP, OHX26PCL, OHX26PCA, 
                               OHX27PCD, OHX27PCM, OHX27PCS, OHX27PCP, OHX27PCL, OHX27PCA, 
                               OHX28PCD, OHX28PCM, OHX28PCS, OHX28PCP, OHX28PCL, OHX28PCA, 
                               OHX29PCD, OHX29PCM, OHX29PCS, OHX29PCP, OHX29PCL, OHX29PCA, 
                               OHX30PCD, OHX30PCM, OHX30PCS, OHX30PCP, OHX30PCL, OHX30PCA, 
                               OHX31PCD, OHX31PCM, OHX31PCS, OHX31PCP, OHX31PCL, OHX31PCA)

#Clearing Variables
rm(final_data_a)
rm(final_data_b)
rm(final_data_c)
rm(final_data_d)
rm(final_data_z)

#Factoring Covariates (0=Female, 1=Male)
ProjData$Gender = factor(ProjData$RIAGENDR, labels = c(1, 0), levels = c(1, 2))

Marital = factor(ProjData$DMDMARTL, labels = c("Married", "Widowed", "Divorced", "Separated", "Never Married", "Living Together", "Refused", "DK"),
                 levels = c(1, 2, 3, 4, 5, 6, 77, 99))
Marital = combineLevels(Marital, levs = c("Married", "Living Together"), newLabel = 1)
Marital = combineLevels(Marital, levs = c("Widowed", "Divorced", "Separated", "Never Married"), newLabel = 0)
ProjData$Marital = combineLevels(Marital, levs = c("Refused"), newLabel = 2)

ProjData$Age = ProjData$RIDAGEYR

Educ = factor(ProjData$DMDEDUC2, labels = c("< 9th", "9-11th", "HS Grad", "SomeCol", "Col Grad", "Refused", "DK"),
              levels = c(1, 2, 3, 4, 5, 7, 9))
Educ = combineLevels(Educ, levs = c("< 9th", "9-11th"), newLabel = 0)
Educ = combineLevels(Educ, levs = "HS Grad", newLabel = 1)
Educ = combineLevels(Educ, levs = "SomeCol", newLabel = 2)
Educ = combineLevels(Educ, levs = "Col Grad", newLabel = 3)
ProjData$Educ = combineLevels(Educ, levs = c("Refused", "DK"), newLabel = 4)

Income = factor(ProjData$INDHHIN2, labels = c("0-4,999", "5-9,999", "10-14,999", "15-19,999", "20-24,999", "25-34,999", "35-44,999", "45-54,999", "55-64,999", "65-74,999", "20,000+", "<20,000", "75-99,999", "100,000+", "Refused", "DK"),
                levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 77, 99))
Income = combineLevels(Income, levs = c("0-4,999", "5-9,999", "10-14,999", "15-19,999", "20-24,999", "25-34,999"),
                       newLabel = 1)
Income = combineLevels(Income, levs = c("35-44,999", "45-54,999", "55-64,999", "65-74,999"),
                       newLabel = 2)
Income = combineLevels(Income, levs = c("75-99,999", "100,000+"), newLabel = 3)
ProjData$Income = combineLevels(Income, levs = c("20,000+", "<20,000", "Refused", "DK"), newLabel = 4)

Dentist = factor(ProjData$OHQ030, labels = c("< 6mo", "6-12mo", "12-24mo", "24-36mo", "36-60", ">50", "Never", "Refused", "DK"),
                 levels = c(1, 2, 3, 4, 5, 6, 7, 77, 99))
Dentist = combineLevels(Dentist, levs = c("Never"), newLabel = 0)
Dentist = combineLevels(Dentist, levs = c("< 6mo", "6-12mo"), newLabel = 1)
Dentist = combineLevels(Dentist, levs = c("12-24mo", "24-36mo"), newLabel = 2)
Dentist = combineLevels(Dentist, levs = c("36-60", ">50"), newLabel = 3)
ProjData$Dentist = combineLevels(Dentist, levs = c("DK"), newLabel = 4)

Flossing = factor(ProjData$OHQ870, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "Refused", "DK"), 
                  levels = c(0, 1, 2, 3, 4, 5, 6, 7, 77, 99))
Flossing = combineLevels(Flossing, levs = c("1", "2", "3"), newLabel = 1)
Flossing = combineLevels(Flossing, levs = c("4", "5", "6"), newLabel = 2)
Flossing = combineLevels(Flossing, levs = "7", newLabel = 3)
ProjData$Flossing = combineLevels(Flossing, levs = c("DK"), newLabel = 4)

MouthWash = factor(ProjData$OHQ875, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "Refused", "DK"), 
                   levels = c(0, 1, 2, 3, 4, 5, 6, 7, 77, 99))
MouthWash = combineLevels(MouthWash, levs = "0", newLabel = 0)
MouthWash = combineLevels(MouthWash, levs = c("1", "2", "3","4", "5", "6", "7"), newLabel = 1)
ProjData$MouthWash = combineLevels(MouthWash, levs = "DK", newLabel = 2)

# Creating periodontal tooth variables (>=4mm) from each pocket depth and LOA tooth's variables 
# (UR2Molar, UR1Molar, UR2Bicuspid, UR1Bicuspid, URCuspid URLIncisor, URCIncisor, ULCIncisor, 
# ULLIncisor, ULCuspid, UL1Bicuspid, UL2Bicuspid, UL1Molar, UL2Molar, LL2Molar, LL1Molar, 
# LL2Bicuspid, LL1Bicuspid, LLCuspid, LLLInciscor, LLCIncisor, LRCIncisor, LRLIncisor, 
# LRCuspid, LR1Bicuspid, LR2Bicuspid, LR1Molar, LR2Molar)

# UR2Molar
#Pocket Depth 
# OHX02PCD (0-8mm)
Depth1 = factor(ProjData$OHX02PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX02PCM (0-7mm)
Depth2 = factor(ProjData$OHX02PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX02PCS (0-8mm)
Depth3 = factor(ProjData$OHX02PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX02PCP (0-9mm)
Depth4 = factor(ProjData$OHX02PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX02PCL (0-6mm)
Depth5 = factor(ProjData$OHX02PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX02PCA (0-8mm)
Depth6 = factor(ProjData$OHX02PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UR2Molar tooth variable from pocket depth and LOA measurements. So below I created 2 intermediate variables. the first is 
# a variable in which the depth is yes or no and the LOA is yes or no. We then have to say that if both of those are yes, then our final variable is disease

UR2Molar=rep(NA, length(Depth1))
UR2Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UR2Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

# UR1Molar
# OHX03PCD (0-9mm)
Depth1 = factor(ProjData$OHX03PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8", "9"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX03PCM (0-8mm)
Depth2 = factor(ProjData$OHX03PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX03PCS (0-8mm)
Depth3 = factor(ProjData$OHX03PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX03PCP (0-8mm)
Depth4 = factor(ProjData$OHX03PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX03PCL (0-5mm)
Depth5 = factor(ProjData$OHX03PCL, labels = c("0", "1", "2", "3", "4", "5", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX03PCA (0-8mm)
Depth6 = factor(ProjData$OHX03PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UR1Molar tooth variable from pocket depth measurements 
UR1Molar=rep(NA, length(Depth1))
UR1Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UR1Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

# UR2Bicuspid
# OHX04PCD (0-8mm)
Depth1 = factor(ProjData$OHX04PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX04PCM (0-6mm)
Depth2 = factor(ProjData$OHX04PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX04PCS (0-8mm)
Depth3 = factor(ProjData$OHX04PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX04PCP (0-7mm)
Depth4 = factor(ProjData$OHX04PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX04PCL (0-8mm)
Depth5 = factor(ProjData$OHX04PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX04PCA (0-8mm)
Depth6 = factor(ProjData$OHX04PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UR2Bicuspid tooth variable from pocket depth measurements 
UR2Bicuspid=rep(NA, length(Depth1))
UR2Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UR2Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)


# UR1Bicuspid
# OHX05PCD (0-7mm)
Depth1 = factor(ProjData$OHX05PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX05PCM (0-6mm)
Depth2 = factor(ProjData$OHX05PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX05PCS (0-11mm)
Depth3 = factor(ProjData$OHX05PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8", "11"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX05PCP (0-8mm)
Depth4 = factor(ProjData$OHX05PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX05PCL (0-8mm)
Depth5 = factor(ProjData$OHX05PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX05PCA (0-8mm)
Depth6 = factor(ProjData$OHX05PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UR1Bicuspid tooth variable from pocket depth measurements 
UR1Bicuspid=rep(NA, length(Depth1))
UR1Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UR1Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

# URCuspid
# OHX06PCD (0-11mm)
Depth1 = factor(ProjData$OHX06PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "12"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX06PCM (0-6mm)
Depth2 = factor(ProjData$OHX06PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX06PCS (0-10mm)
Depth3 = factor(ProjData$OHX06PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8", "9", "10"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX06PCP (0-8mm)
Depth4 = factor(ProjData$OHX06PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX06PCL (0-8mm)
Depth5 = factor(ProjData$OHX06PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX06PCA (0-9mm)
Depth6 = factor(ProjData$OHX06PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating URCuspid tooth variable from pocket depth measurements 
URCuspid=rep(NA, length(Depth1))
URCuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
URCuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

# URLIncisor
# OHX07PCD (0-11mm)
Depth1 = factor(ProjData$OHX07PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "11"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX07PCM (0-6mm)
Depth2 = factor(ProjData$OHX07PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX07PCS (0-7mm)
Depth3 = factor(ProjData$OHX07PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX07PCP (0-10mm)
Depth4 = factor(ProjData$OHX07PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "10"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX07PCL (0-8mm)
Depth5 = factor(ProjData$OHX07PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX07PCA (0-8mm)
Depth6 = factor(ProjData$OHX07PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating URLIncisor tooth variable from pocket depth measurements 
URLIncisor=rep(NA, length(Depth1))
URLIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
URLIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

# URCIncisor
# OHX08PCD (0-7mm)
Depth1 = factor(ProjData$OHX08PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX08PCM (0-7mm)
Depth2 = factor(ProjData$OHX08PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX08PCS (0-9mm)
Depth3 = factor(ProjData$OHX08PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "9"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX08PCP (0-8mm)
Depth4 = factor(ProjData$OHX08PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX08PCL (0-7mm)
Depth5 = factor(ProjData$OHX08PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX08PCA (0-8mm)
Depth6 = factor(ProjData$OHX08PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating URCIncisor tooth variable from pocket depth measurements 
URCIncisor=rep(NA, length(Depth1))
URCIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
URCIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#ULCIncisor
# OHX09PCD (0-8mm)
Depth1 = factor(ProjData$OHX09PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX09PCM (0-10mm)
Depth2 = factor(ProjData$OHX09PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "9", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX09PCS (0-10mm)
Depth3 = factor(ProjData$OHX09PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "10"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX09PCP (0-7mm)
Depth4 = factor(ProjData$OHX09PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX09PCL (0-6mm)
Depth5 = factor(ProjData$OHX09PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX09PCA (0-8mm)
Depth6 = factor(ProjData$OHX09PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating ULCIncisor tooth variable from pocket depth measurements 
ULCIncisor=rep(NA, length(Depth1))
ULCIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
ULCIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)
rm(UR2Inter1)
rm(UR2Inter2)

#ULLIncisor
# OHX10PCD (0-8mm)
Depth1 = factor(ProjData$OHX10PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX10PCM (0-8mm)
Depth2 = factor(ProjData$OHX10PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX10PCS (0-7mm)
Depth3 = factor(ProjData$OHX10PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX10PCP (0-9mm)
Depth4 = factor(ProjData$OHX10PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX10PCL (0-9mm)
Depth5 = factor(ProjData$OHX10PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX10PCA (0-8mm)
Depth6 = factor(ProjData$OHX10PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating ULLIncisor tooth variable from pocket depth measurements 
ULLIncisor=rep(NA, length(Depth1))
ULLIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
ULLIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#ULCuspid
# OHX11PCD (0-9mm)
Depth1 = factor(ProjData$OHX11PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX11PCM (0-10mm)
Depth2 = factor(ProjData$OHX11PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX11PCS (0-8mm)
Depth3 = factor(ProjData$OHX11PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX11PCP (0-8mm)
Depth4 = factor(ProjData$OHX11PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX11PCL (0-11mm)
Depth5 = factor(ProjData$OHX11PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7", "9", "11"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX11PCA (0-9mm)
Depth6 = factor(ProjData$OHX11PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating ULCuspid tooth variable from pocket depth measurements 
ULCuspid=rep(NA, length(Depth1))
ULCuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
ULCuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#UL1Bicuspid
# OHX12PCD (0-8mm)
Depth1 = factor(ProjData$OHX12PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX12PCM (0-6mm)
Depth2 = factor(ProjData$OHX12PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX12PCS (0-8mm)
Depth3 = factor(ProjData$OHX12PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX12PCP (0-8mm)
Depth4 = factor(ProjData$OHX12PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX12PCL (0-6mm)
Depth5 = factor(ProjData$OHX12PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX12PCA (0-8mm)
Depth6 = factor(ProjData$OHX12PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UL1Bicuspid tooth variable from pocket depth measurements 
UL1Bicuspid=rep(NA, length(Depth1))
UL1Bicuspidwhich[(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UL1Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#UL2Bicuspid
# OHX13PCD (0-8mm)
Depth1 = factor(ProjData$OHX13PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX13PCM (0-10mm)
Depth2 = factor(ProjData$OHX13PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX13PCS (0-10mm)
Depth3 = factor(ProjData$OHX13PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8", "10"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX13PCP (0-8mm)
Depth4 = factor(ProjData$OHX13PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX13PCL (0-7mm)
Depth5 = factor(ProjData$OHX13PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX13PCA (0-8mm)
Depth6 = factor(ProjData$OHX13PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UL2Bicuspid tooth variable from pocket depth measurements 
UL2Bicuspid=rep(NA, length(Depth1))
UL2Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UL2Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#UL1Molar
# OHX14PCD (0-10mm)
Depth1 = factor(ProjData$OHX14PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX14PCM (0-10mm)
Depth2 = factor(ProjData$OHX14PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX14PCS (0-10mm)
Depth3 = factor(ProjData$OHX14PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7",  "10"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX14PCP (0-9mm)
Depth4 = factor(ProjData$OHX14PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX14PCL (0-8mm)
Depth5 = factor(ProjData$OHX14PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "7", "8"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX14PCA (0-8mm)
Depth6 = factor(ProjData$OHX14PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UL1Molar tooth variable from pocket depth measurements 
UL1Molar=rep(NA, length(Depth1))
UL1Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UL1Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)


#UL2Molar
# OHX15PCD (0-9mm)
Depth1 = factor(ProjData$OHX15PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX15PCM (0-10mm)
Depth2 = factor(ProjData$OHX15PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "9", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX15PCS (0-9mm)
Depth3 = factor(ProjData$OHX15PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX15PCP (0-9mm)
Depth4 = factor(ProjData$OHX15PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX15PCL (0-9mm)
Depth5 = factor(ProjData$OHX15PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7", "9"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX15PCA (0-10mm)
Depth6 = factor(ProjData$OHX15PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8", "9", "10"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating UL2Molar tooth variable from pocket depth measurements 
UL2Molar=rep(NA, length(Depth1))
UL2Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
UL2Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LL2Molar
# OHX18PCD (0-10mm)
Depth1 = factor(ProjData$OHX18PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "9", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX18PCM (0-10mm)
Depth2 = factor(ProjData$OHX18PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7", "8", "9", "10"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX18PCS (0-11mm)
Depth3 = factor(ProjData$OHX18PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8", "11"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX18PCP (0-10mm)
Depth4 = factor(ProjData$OHX18PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8", "9", "10"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX18PCL (0-7mm)
Depth5 = factor(ProjData$OHX18PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX18PCA (0-8mm)
Depth6 = factor(ProjData$OHX18PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LL2Molar tooth variable from pocket depth measurements 
LL2Molar=rep(NA, length(Depth1))
LL2Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LL2Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LL1Molar
# OHX19PCD (0-8mm)
Depth1 = factor(ProjData$OHX19PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX19PCM (0-9mm)
Depth2 = factor(ProjData$OHX19PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX19PCS (0-8mm)
Depth3 = factor(ProjData$OHX19PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX19PCP (0-8mm)
Depth4 = factor(ProjData$OHX19PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX19PCL (0-7mm)
Depth5 = factor(ProjData$OHX19PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX19PCA (0-6mm)
Depth6 = factor(ProjData$OHX19PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LL1Molar tooth variable from pocket depth measurements 
LL1Molar=rep(NA, length(Depth1))
LL1Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LL1Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LL2Bicuspid
# OHX20PCD (0-10mm)
Depth1 = factor(ProjData$OHX20PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX20PCM (0-7mm)
Depth2 = factor(ProjData$OHX20PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX20PCS (0-8mm)
Depth3 = factor(ProjData$OHX20PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX20PCP (0-8mm)
Depth4 = factor(ProjData$OHX20PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX20PCL (0-7mm)
Depth5 = factor(ProjData$OHX20PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX20PCA (0-7mm)
Depth6 = factor(ProjData$OHX20PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LL2Bicuspid tooth variable from pocket depth measurements 
LL2Bicuspid=rep(NA, length(Depth1))
LL2Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LL2Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LL1Bicuspid
# OHX21PCD (0-10mm)
Depth1 = factor(ProjData$OHX21PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX21PCM (0-7mm)
Depth2 = factor(ProjData$OHX21PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX21PCS (0-8mm)
Depth3 = factor(ProjData$OHX21PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX21PCP (0-8mm)
Depth4 = factor(ProjData$OHX21PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX21PCL (0-7mm)
Depth5 = factor(ProjData$OHX21PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX21PCA (0-7mm)
Depth6 = factor(ProjData$OHX21PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LL1Bicuspid tooth variable from pocket depth measurements 
LL1Bicuspid=rep(NA, length(Depth1))
LL1Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LL1Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LLCuspid
# OHX22PCD (0-10mm)
Depth1 = factor(ProjData$OHX22PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX22PCM (0-7mm)
Depth2 = factor(ProjData$OHX22PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX22PCS (0-8mm)
Depth3 = factor(ProjData$OHX22PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX22PCP (0-8mm)
Depth4 = factor(ProjData$OHX22PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX22PCL (0-7mm)
Depth5 = factor(ProjData$OHX22PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX22PCA (0-7mm)
Depth6 = factor(ProjData$OHX22PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LLCuspid tooth variable from pocket depth measurements 
LLCuspid=rep(NA, length(Depth1))
LLCuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LLCuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LLLInciscor
# OHX23PCD (0-10mm)
Depth1 = factor(ProjData$OHX23PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX23PCM (0-7mm)
Depth2 = factor(ProjData$OHX23PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX23PCS (0-8mm)
Depth3 = factor(ProjData$OHX23PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX23PCP (0-8mm)
Depth4 = factor(ProjData$OHX23PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX23PCL (0-7mm)
Depth5 = factor(ProjData$OHX23PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX23PCA (0-7mm)
Depth6 = factor(ProjData$OHX23PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LLLIncisor tooth variable from pocket depth measurements 
LLLIncisor=rep(NA, length(Depth1))
LLLIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LLLIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)


#LLCInciscor
# OHX24PCD (0-10mm)
Depth1 = factor(ProjData$OHX24PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX24PCM (0-7mm)
Depth2 = factor(ProjData$OHX24PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX24PCS (0-8mm)
Depth3 = factor(ProjData$OHX24PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX24PCP (0-8mm)
Depth4 = factor(ProjData$OHX24PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX24PCL (0-7mm)
Depth5 = factor(ProjData$OHX24PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX24PCA (0-7mm)
Depth6 = factor(ProjData$OHX24PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LLCIncisor tooth variable from pocket depth measurements 
LLCIncisor=rep(NA, length(Depth1))
LLCIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LLCIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"



#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LRCInciscor
# OHX25PCD (0-10mm)
Depth1 = factor(ProjData$OHX25PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX25PCM (0-7mm)
Depth2 = factor(ProjData$OHX25PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX25PCS (0-8mm)
Depth3 = factor(ProjData$OHX25PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX25PCP (0-8mm)
Depth4 = factor(ProjData$OHX25PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX25PCL (0-7mm)
Depth5 = factor(ProjData$OHX25PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX25PCA (0-7mm)
Depth6 = factor(ProjData$OHX25PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LRCIncisor tooth variable from pocket depth measurements 
LRCIncisor=rep(NA, length(Depth1))
LRCIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LRCIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)


#LRLInciscor
# OHX26PCD (0-10mm)
Depth1 = factor(ProjData$OHX26PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCM (0-7mm)
Depth2 = factor(ProjData$OHX26PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCS (0-8mm)
Depth3 = factor(ProjData$OHX26PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCP (0-8mm)
Depth4 = factor(ProjData$OHX26PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCL (0-7mm)
Depth5 = factor(ProjData$OHX26PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCA (0-7mm)
Depth6 = factor(ProjData$OHX26PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LRLIncisor tooth variable from pocket depth measurements 
LRLIncisor=rep(NA, length(Depth1))
LRLIncisor[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LRLIncisor[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LRCuspid
# OHX26PCD (0-10mm)
Depth1 = factor(ProjData$OHX26PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCM (0-7mm)
Depth2 = factor(ProjData$OHX26PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCS (0-8mm)
Depth3 = factor(ProjData$OHX26PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCP (0-8mm)
Depth4 = factor(ProjData$OHX26PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCL (0-7mm)
Depth5 = factor(ProjData$OHX26PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX26PCA (0-7mm)
Depth6 = factor(ProjData$OHX26PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LRCuspid tooth variable from pocket depth measurements 
LRCuspid=rep(NA, length(Depth1))
LRCuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LRCuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LR1Bicuspid
# OHX27PCD (0-10mm)
Depth1 = factor(ProjData$OHX27PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8", "9"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX27PCM (0-7mm)
Depth2 = factor(ProjData$OHX27PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX27PCS (0-8mm)
Depth3 = factor(ProjData$OHX27PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX27PCP (0-8mm)
Depth4 = factor(ProjData$OHX27PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX27PCL (0-7mm)
Depth5 = factor(ProjData$OHX27PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX27PCA (0-7mm)
Depth6 = factor(ProjData$OHX27PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LR1Bicuspid tooth variable from pocket depth measurements 
LR1Bicuspid=rep(NA, length(Depth1))
LR1Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LR1Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)


#LR2Bicuspid
# OHX28PCD (0-10mm)
Depth1 = factor(ProjData$OHX28PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "10"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX28PCM (0-7mm)
Depth2 = factor(ProjData$OHX28PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX28PCS (0-8mm)
Depth3 = factor(ProjData$OHX28PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX28PCP (0-8mm)
Depth4 = factor(ProjData$OHX28PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX28PCL (0-7mm)
Depth5 = factor(ProjData$OHX28PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX28PCA (0-7mm)
Depth6 = factor(ProjData$OHX28PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LR2Bicuspid tooth variable from pocket depth measurements 
LR2Bicuspid=rep(NA, length(Depth1))
LR2Bicuspid[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LR2Bicuspid[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LR1Molar
# OHX29PCD (0-10mm)
Depth1 = factor(ProjData$OHX29PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX29PCM (0-7mm)
Depth2 = factor(ProjData$OHX29PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX29PCS (0-8mm)
Depth3 = factor(ProjData$OHX29PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX29PCP (0-8mm)
Depth4 = factor(ProjData$OHX29PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX29PCL (0-7mm)
Depth5 = factor(ProjData$OHX29PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX29PCA (0-7mm)
Depth6 = factor(ProjData$OHX29PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LR1Molar tooth variable from pocket depth measurements 
LR1Molar=rep(NA, length(Depth1))
LR1Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LR1Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"


#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#LR2Molar
# OHX30PCD (0-10mm)
Depth1 = factor(ProjData$OHX30PCD, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 99))
Depth1 = combineLevels(Depth1, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth1 = combineLevels(Depth1, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth1 = combineLevels(Depth1, levs = c("99"), newLabel = "Cannot be assessed")

# OHX30PCM (0-7mm)
Depth2 = factor(ProjData$OHX30PCM, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth2 = combineLevels(Depth2, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth2 = combineLevels(Depth2, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth2 = combineLevels(Depth2, levs = c("99"), newLabel = "Cannot be assessed")

# OHX30PCS (0-8mm)
Depth3 = factor(ProjData$OHX30PCS, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth3 = combineLevels(Depth3, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth3 = combineLevels(Depth3, levs = c("4", "5", "6", "7", "8"), newLabel = "Yes")
Depth3 = combineLevels(Depth3, levs = c("99"), newLabel = "Cannot be assessed")

# OHX30PCP (0-8mm)
Depth4 = factor(ProjData$OHX30PCP, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 99))
Depth4 = combineLevels(Depth4, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth4 = combineLevels(Depth4, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth4 = combineLevels(Depth4, levs = c("99"), newLabel = "Cannot be assessed")

# OHX30PCL (0-7mm)
Depth5 = factor(ProjData$OHX30PCL, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth5 = combineLevels(Depth5, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth5 = combineLevels(Depth5, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth5 = combineLevels(Depth5, levs = c("99"), newLabel = "Cannot be assessed")

# OHX30PCA (0-7mm)
Depth6 = factor(ProjData$OHX30PCA, labels = c("0", "1", "2", "3", "4", "5", "6", "7", "99"),
                levels = c(0, 1, 2, 3, 4, 5, 6, 7, 99))
Depth6 = combineLevels(Depth6, levs = c("0", "1", "2", "3"), newLabel = "No")
Depth6 = combineLevels(Depth6, levs = c("4", "5", "6", "7"), newLabel = "Yes")
Depth6 = combineLevels(Depth6, levs = c("99"), newLabel = "Cannot be assessed")

# Creating LR2Molar tooth variable from pocket depth measurements 
LR2Molar=rep(NA, length(Depth1))
LR2Molar[which(Depth1=="Yes" | Depth2=="Yes" | Depth3=="Yes" | Depth4=="Yes" | Depth5=="Yes" | Depth6=="Yes")]="Yes"
LR2Molar[which(Depth1=="No" & Depth2=="No" & Depth3=="No" & Depth4=="No" & Depth5=="No" & Depth6=="No")]="No"

#Clearing pocket depth and LOA variables
rm(Depth1)
rm(Depth2)
rm(Depth3)
rm(Depth4)
rm(Depth5)
rm(Depth6)

#Creating overall Periodontal variable from individual tooth variables by quadrant
PeriSum= function(a){
  l=length(a)
  x=numeric(l)
  for(i in 1:l){
    x[i]=ifelse(a[i]== "Yes", 1, ifelse(a[i]== "No", 0, 0))
  }
  sum(x, na.rm=T)
}


UR = data.frame(URLIncisor, URCuspid, URCIncisor, UR2Molar, UR2Bicuspid, UR1Molar, UR1Bicuspid)
UL = data.frame(ULLIncisor, ULCuspid, ULCIncisor, UL2Molar, UL2Bicuspid, UL1Molar, UL1Bicuspid)
LR = data.frame(LRLIncisor, LRCuspid, LRCIncisor, LR2Molar, LR2Bicuspid, LR1Molar, LR1Bicuspid)
LL = data.frame(LLLIncisor, LLCuspid, LLCIncisor, LL2Molar, LL2Bicuspid, LL1Molar, LL1Bicuspid)

UR$sum = apply(UR, 1, PeriSum)
UL$sum = apply(UL, 1, PeriSum)
LR$sum = apply(LR, 1, PeriSum)
LL$sum = apply(LL, 1, PeriSum)

ProjData$Periodontal =rep(NA, length(LL1Molar))
ProjData$Periodontal[which(UR$sum >= 2 | UL$sum >= 2 | LR$sum >= 2 | LL$sum >= 2)]= 1
ProjData$Periodontal[which(UR$sum < 2 & UL$sum < 2 & LR$sum < 2 & LL$sum < 2)]= 0

table(ProjData$Periodontal)



#Making Factor Variables and Combining Levels
PeriStat = factor(ProjData$OHDPDSTS, 
                  labels = c("Complete", "Partial", "NotDone"), 
                  levels = c(1, 2, 3))
#Oral Sex on Woman
OSW = factor(ProjData$SXQ803, 
             labels = c("Yes", "No", "Refuse", "DK"),
             levels = c(1, 2, 7, 9))
OSW = combineLevels(OSW, levs = c("Refuse", "DK"), newLabel = "Refuse/DK")
#Oral Sex on Man
OSM = factor(ProjData$SXQ703, 
             labels = c("Yes", "No", "Refuse", "DK"),
             levels = c(1, 2, 7, 9))
OSM = combineLevels(OSM, levs = c("Refuse", "DK"), newLabel = "Refuse/DK")

#Oral Sex Overall
ProjData$OralSex=rep(NA, length(OSW))
ProjData$OralSex[which(OSM=="Yes" | OSW=="Yes")]= 1
ProjData$OralSex[which(OSM=="No"  | OSW=="No")]= 0
ProjData$OralSex[which(OSM=="Refuse/DK"  | OSW=="Refuse/DK")]= 2

#Checking to verify the bivariate distribution of having a complete or partial periodontal 
#examination and responding to Oral Sex on a Woman

table(PeriStat, OSW)
table(PeriStat, OSM)
table(PeriStat, ProjData$OralSex)

table(ProjData$OralSex, ProjData$Periodontal)
table(ProjData$OralSex)


#Prior to Analyses
DataSurvey = svydesign(id=~SDMVPSU, strata=~SDMVSTRA, nest=T, weights=~WTMEC2YR, data=ProjData)

#Analyses (Use DataSurvey... Not ProjData)
svyglm(Periodontal~OralSex, design=DataSurvey, family=binomial(link=logit))

#Table 1 (unweighted counts and weighted percentages)
table(ProjData$OralSex)
svytable(~OralSex, design = DataSurvey, Ntotal = 100)
A1=data.frame(cbind(table(ProjData$OralSex), svytable(~OralSex, design = DataSurvey, Ntotal = 100)))

table(ProjData$Periodontal)
svytable(~Periodontal, design = DataSurvey, Ntotal = 100)
B1=data.frame(cbind(table(ProjData$Periodontal), svytable(~Periodontal, design = DataSurvey, Ntotal = 100)))

table(ProjData$Dentist)
svytable(~Dentist, design = DataSurvey, Ntotal = 100)
C1=data.frame(cbind(table(ProjData$Dentist), svytable(~Dentist, design = DataSurvey, Ntotal = 100)))

table(ProjData$Flossing)
svytable(~Flossing, design = DataSurvey, Ntotal = 100)
D1=data.frame(cbind(table(ProjData$Flossing), svytable(~Flossing, design = DataSurvey, Ntotal = 100)))

table(ProjData$MouthWash)
svytable(~MouthWash, design = DataSurvey, Ntotal = 100)
E1=data.frame(cbind(table(ProjData$MouthWash), svytable(~MouthWash, design = DataSurvey, Ntotal = 100)))

table(ProjData$Gender)
svytable(~Gender, design = DataSurvey, Ntotal = 100)
F1=data.frame(cbind(table(ProjData$Gender), svytable(~Gender, design = DataSurvey, Ntotal = 100)))

table(ProjData$Educ)
svytable(~Educ, design = DataSurvey, Ntotal = 100)
G1=data.frame(cbind(table(ProjData$Educ), svytable(~Educ, design = DataSurvey, Ntotal = 100)))

table(ProjData$Marital)
svytable(~Marital, design = DataSurvey, Ntotal = 100)
H1=data.frame(cbind(table(ProjData$Marital), svytable(~Marital, design = DataSurvey, Ntotal = 100)))

table(ProjData$Income)
svytable(~Income, design = DataSurvey, Ntotal = 100)
I1=data.frame(cbind(table(ProjData$Income), svytable(~Income, design = DataSurvey, Ntotal = 100)))

#Table1
J1= data.frame(rbind(A1, B1, C1, D1, E1, F1, G1, H1, I1))
rownames(J1)= c("Yes","No","Dk/Refused","yes","no","Never","<12mo","12-35mo","36mo+","R/DK",
                "never","1-3/wk","4-6/wk","Daily","Refuse/dk","Don't Use","Use","Refuse/DK","Male",
                "Female","<12th","HS Grad","Some College","College Grad", "Refused/DK", 
                "Married/Living Together", "Single/Div/Widow","Refuse/Dk", "0-34,999", "35-74,999",
                "75-99,999", "100,000+")
colnames(J1)= c("Sample Count", "Weighted Percentage")

#Mean (SE) and Median (IQR)
svymean(~Age, design = DataSurvey, na.rm=T)
svyquantile(~Age, design = DataSurvey, quantiles = c(.25, .5, .75), na.rm=T)

#Prior to Analyses, 2nd subset getting rid of Refused/DK
SubsetProj = subset(ProjData, OralSex != 2)
SubsetProj = subset(SubsetProj, Dentist  !=4)
SubsetProj = subset(SubsetProj, Flossing != 4)
SubsetProj = subset(SubsetProj, MouthWash != 2)
SubsetProj = subset(SubsetProj, Educ != 4)
SubsetProj = subset(SubsetProj, Income != 4)
SubsetProj = subset(SubsetProj, Marital != 2)
SubsetProj$Dentist = droplevels(SubsetProj$Dentist)
SubsetProj$Flossing = droplevels(SubsetProj$Flossing)
SubsetProj$MouthWash = droplevels(SubsetProj$MouthWash)
SubsetProj$Educ = droplevels(SubsetProj$Educ)
SubsetProj$Income = droplevels(SubsetProj$Income)
SubsetProj$Marital = droplevels(SubsetProj$Marital)

DataSurvey2 = svydesign(id=~SDMVPSU, strata=~SDMVSTRA, nest=T, weights=~WTMEC2YR, data=SubsetProj)

#Bivariate analyses
table(SubsetProj$OralSex, SubsetProj$Periodontal)
svytable(~OralSex+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~OralSex+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Dentist, SubsetProj$Periodontal)
svytable(~Dentist+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Dentist+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Flossing, SubsetProj$Periodontal)
svytable(~Flossing+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Flossing+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$MouthWash, SubsetProj$Periodontal)
svytable(~MouthWash+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~MouthWash+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Gender, SubsetProj$Periodontal)
svytable(~Gender+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Gender+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Educ, SubsetProj$Periodontal)
svytable(~Educ+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Educ+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Marital, SubsetProj$Periodontal)
svytable(~Marital+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Marital+Periodontal, design = DataSurvey2, Ntotal = 100)

table(SubsetProj$Income, SubsetProj$Periodontal)
svytable(~Income+Periodontal, design = DataSurvey2, Ntotal = 100)
svychisq(~Income+Periodontal, design = DataSurvey2, Ntotal = 100)

svyttest(Age~Periodontal, design = DataSurvey2)

B1=svyglm(Periodontal~OralSex, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B1)
cbind(exp(coef(B1)), exp(confint(B1)))

B2=svyglm(Periodontal~Dentist, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B2)
cbind(exp(coef(B2)), exp(confint(B2)))

B3=svyglm(Periodontal~Flossing, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B3)
cbind(exp(coef(B3)), exp(confint(B3)))

B4=svyglm(Periodontal~MouthWash, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B4)
cbind(exp(coef(B4)), exp(confint(B4)))

B5=svyglm(Periodontal~Gender, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B5)
cbind(exp(coef(B5)), exp(confint(B5)))

B6=svyglm(Periodontal~Educ, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B6)
cbind(exp(coef(B6)), exp(confint(B6)))

B7=svyglm(Periodontal~Marital, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B7)
cbind(exp(coef(B7)), exp(confint(B7)))

B8=svyglm(Periodontal~Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(B8)
cbind(exp(coef(B8)), exp(confint(B8)))

#Crude Logistic Regression
G=svyglm(Periodontal~OralSex, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G)
cbind(exp(coef(G)), exp(confint(G)))

#Adjusted Logistic Regressions
G1=svyglm(Periodontal~OralSex+Dentist, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G1)
cbind(exp(coef(G1)), exp(confint(G1)))

G2=svyglm(Periodontal~OralSex+Flossing, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G2)
cbind(exp(coef(G2)), exp(confint(G2)))

G3=svyglm(Periodontal~OralSex+MouthWash, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G3)
cbind(exp(coef(G3)), exp(confint(G3)))

G4=svyglm(Periodontal~OralSex+Gender, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G4)
cbind(exp(coef(G4)), exp(confint(G4)))

G5=svyglm(Periodontal~OralSex+Educ, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G5)
cbind(exp(coef(G5)), exp(confint(G5)))

G6=svyglm(Periodontal~OralSex+Marital, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G6)
cbind(exp(coef(G6)), exp(confint(G6)))

G7=svyglm(Periodontal~OralSex+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G7)
cbind(exp(coef(G7)), exp(confint(G7)))

G8=svyglm(Periodontal~OralSex+Age, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G8)
cbind(exp(coef(G8)), exp(confint(G8)))

#Model With Everything
GFullish=svyglm(Periodontal~OralSex+Dentist+Gender+Educ+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(GFullish)
cbind(exp(coef(GFullish)), exp(confint(GFullish)))

GFull=svyglm(Periodontal~OralSex+Dentist+Flossing+MouthWash+Gender+Educ+Marital+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(GFull)
cbind(exp(coef(GFull)), exp(confint(GFull)))

regTermTest(GFull, "Dentist")
regTermTest(GFull, "Flossing")
regTermTest(GFull, "MouthWash")
regTermTest(GFull, "Gender")
regTermTest(GFull, "Educ")
regTermTest(GFull, "Marital")
regTermTest(GFull, "Income")

#Fully Adjusted Regression with some Selected Confounders
G8=svyglm(Periodontal~OralSex+Dentist+Flossing+Gender+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G8)
cbind(exp(coef(G8)), exp(confint(G8)))
Model8=cbind(exp(coef(G8)), exp(confint(G8)))

#Removed flossing due to possible colinearity with Visiting the Dentist
G9=svyglm(Periodontal~OralSex+Dentist+Gender+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G9)
cbind(exp(coef(G9)), exp(confint(G9)))
Model9=cbind(exp(coef(G9)), exp(confint(G9)))

G10=svyglm(Periodontal~OralSex+Dentist+Gender, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G10)
cbind(exp(coef(G10)), exp(confint(G10)))
Model10=cbind(exp(coef(G10)), exp(confint(G10)))

G11=svyglm(Periodontal~OralSex+Dentist+Income, design = DataSurvey2, family=quasibinomial(link=logit))
summary(G11)
cbind(exp(coef(G11)), exp(confint(G11)))
Model11=cbind(exp(coef(G11)), exp(confint(G11)))

ORs= data.frame(Model8[2,], Model9[2,], Model10[2,], Model11[2,])
ORs= t(ORs)
rownames(ORs) = c("Model 8", "Model 9", "Model 10", "Model 11")
colnames(ORs) = c("Odds Ratio", "Lower Bound", "Upper Bound")

#Analysis of Deviance
anova(G8, G9)
anova(G8, G11)
regTermTest(G8, "Dentist")
regTermTest(G8, "Flossing")
regTermTest(G8, "Gender")
regTermTest(G8, "Income")

#Graphs and Tables
#Table1
J1= data.frame(rbind(A1, B1, C1, D1, E1, F1, G1, H1, I1))
rownames(J1)= c("Yes","No","Dk/Refused","yes","no","Never","<12mo","12-35mo","36mo+","R/DK",
                "never","1-3/wk","4-6/wk","Daily","Refuse/dk","Don't Use","Use","Refuse/DK","Male",
                "Female","<12th","HS Grad","Some College","College Grad", "Refused/DK", 
                "Married/Living Together", "Single/Div/Widow","Refuse/Dk", "0-34,999", "35-74,999",
                "75-99,999", "100,000+")
colnames(J1)= c("Sample Count", "Weighted Percentage")

#OR Table
kable(ORs, format = "html", booktabs = T) %>%
  kable_styling() %>%
  footnote(general = "Model Specifics",
           number = c("Model 8: Controlling for Dentist, Flossing, Gender, and Income ", 
                      "Model 9: Controlling for Dentist, Gender, and Income",
                      "Model 10: Controlling for Dentist and Gender",
                      "Model 11: Controlling for Dentist and Income"))%>%
  add_header_above(c("Logistic Model" = 1, "Point Estimate" = 1, "95% Confidence Interval" = 2))

kable(J1, format = "html", booktabs = T, full_width = T) %>%
  kable_styling() %>%
  group_rows(index = c("OralSex" = 3, "Periodontal Disease" = 2, "Last Dental Visit" = 5, 
                       "Flossing" = 5, "Mouth Wash" = 3, "Gender" = 2, "Education" = 5,
                       "Marital Status" = 3, "Annual Household Income" = 4)) 

#t-test for difference in means of Age by Periodontal
svyttest(Age~Periodontal, design = DataSurvey2)

barplot(ProjData$Periodontal)
?barplot

g1=glm(Periodontal~OralSex, data=ProjData,
             family=binomial(link="logit"))
summary(g1)

library(dplyr)
library(tidyr)
library(scales)
library(ggplot2)

a<-ggplot(ProjData, aes(x=Periodontal, y=Age))
a+geom_point(aes(col=Age))+
  labs(x="Gum Disease", y="Age (years)", title="Bivariate Analysis of Gum Disease and Age")

q<-ggplot(ProjData, aes(x=Periodontal, y=Dentist, fill=Dentist))
q+geom_jitter(aes(col=Dentist)) + theme_bw() +
  labs(x="Gum Disease status", y="Last Dental Visit", title="Gum disease versus Last dental visit")

q<-ggplot(ProjData, aes(x=Periodontal, y=Gender, fill=Gender))
q+geom_jitter(aes(col=Gender)) + theme_bw() +
  labs(x="Gum Disease status", y="Gender category", title="Gum disease versus Gender category")

q<-ggplot(ProjData, aes(x=Periodontal, y=Educ, fill=Educ))
q+geom_jitter(aes(col=Educ)) + theme_bw() +
  labs(x="Gum Disease status", y="Education category", title="Gum disease versus Education category")
q<-ggplot(ProjData, aes(x=Periodontal, y=Income, fill=Income))
q+geom_jitter(aes(col=Income)) + theme_bw() +
  labs(x="Gum Disease status", y="Household income category", title="Gum disease versus Household income category")
?geom_jitter()

#survey bar chart example
#svychisq(~periodontal+tired, nhanessvy, statistics = c("chisq""))

#survey graph: oral sex and periodontal disease
#oral sex and dentist visits
#like the low birth weight and gender graphs

counts <- table(ProjData$Periodontal, ProjData$Age)
barplot(counts, main="Gum Disease and Age", 
         xlab="Age", col=c("black", "darkgray"),
        xlim=c(0,80), ylim=c(0,350),
         legend= rownames(counts))
counts1 <-table(ProjData$Periodontal, ProjData$OralSex)
barplot(counts1, main="Gum Disease and Oral Sex", 
        xlab="Oral Sex", col=c("black", "darkgray"),
        xlim=c(0,4), ylim=c(0,2500),
        legend= rownames(counts))
counts2 <-table(ProjData$Periodontal, ProjData$Dentist)
barplot(counts2, main="Gum Disease and Dental Visits", 
        xlab="Dental Visits", col=c("black", "darkgray"),
        xlim=c(0,10), ylim=c(0,3000),
        legend= rownames(counts))
counts3 <-table(ProjData$Periodontal, ProjData$Educ)
barplot(counts3, main="Gum Disease and Education", 
        xlab="Education level", col=c("black", "darkgray"),
        xlim=c(0,10), ylim=c(0,1500),
        legend= rownames(counts))
counts4 <-table(ProjData$Periodontal, ProjData$Gender)
barplot(counts4, main="Gum Disease and Gender category", 
        xlab="Gender category", col=c("black", "darkgray"),
        xlim=c(0,5), ylim=c(0,3000),
        legend= rownames(counts))
OralSexBar=c(14,86)
barplot(OralSexBar, main="Weighted proportion of Oral Sex",
        xlab="Ever Performed Oral Sex", col=c("black", "darkgray"),
        ylab="Percentage",
        xlim=c(0,5), ylim=c(0,100),
        legend=c("Yes", "No"))
OralSexBar1=c(1, 61, 18, 20)
barplot(OralSexBar1, main="Weighted proportion of Dental Visits", 
        xlab="Last Dental Visit", col=c("black", "darkgray", "lightgray", "white"), 
        ylab="Percentage",
xlim=c(0,10), ylim=c(0,65),
legend=c("Never", "<12 months", "12-35 months", "36+ months"))
OralSexBar2=c(48, 52)
barplot(OralSexBar2, main="Weighted proportion of Gender", 
        xlab="Gender category", col=c("black", "darkgray"), 
        ylab="Percentage",
        xlim=c(0,10), ylim=c(0,55),
        legend=c("Male", "Female"))
OralSexBar3=c(82, 17)
barplot(OralSexBar3, main="        Weighted proportion 
        of Gum Disease", 
        xlab="Gum Disease presence", col=c("black", "darkgray"), 
        ylab="Percentage",
        xlim=c(0,10), ylim=c(0,85),
        legend=c("No", "Yes"))

x <- c(70, 30)
y <- c(78, 22)
# create a two row matrix with x and y
height <- rbind(x, y)
# Use height and set 'beside = TRUE' to get pairs
# save the bar midpoints in 'mp'
# Set the bar pair labels to A:D
mp <- barplot(height, beside = TRUE, main ="              Weighted Percentages of 
              Oral Sex vs Gum Disease", 
              xlab="Oral Sex Status",
              ylab="percentage",
              xlim=c(0,9), 
              ylim = c(0, 100), 
              names.arg=c("Yes", "No"),
              legend=c("Gum Disease", "No Gum Disease"))
text(mp, height, labels = format(height, 4),
     pos = 3, cex = .75)
x <- c(3, 42, 24, 31)
y <- c(1, 61, 20, 19)
height <- rbind(x, y)
mp <- barplot(height, beside = TRUE, main ="Weighted Percentages of Last 
Dental Visit vs Gum Disease", 
              xlab="Last Dental  (in months)",
              ylab="percentage",
              xlim=c(0,11.5), 
              ylim = c(0, 100), 
              names.arg=c("Never", "<12", "12-35", "36+"),
              legend=c("Gum Disease", "No Gum Disease"))
text(mp, height, labels = format(height, 4),
     pos = 3.8, cex = .75)
x <- c(64, 36)
y <- c(45, 55)
height <- rbind(x, y)
mp <- barplot(height, beside = TRUE, main ="Weighted Percentages of Gender 
Category vs Gum Disease", 
              xlab="Gender Category",
              ylab="percentage",
              xlim=c(0,10), 
              ylim = c(0, 100), 
              names.arg=c("Male", "Female"),
              legend=c("Gum Disease", "No Gum Disease"))
text(mp, height, labels = format(height, 4),
     pos = 3.8, cex = .75)
x <- c(28, 27, 30, 15)
y <- c(19, 18, 39, 34)
height <- rbind(x, y)
mp <- barplot(height, beside = TRUE, main ="     Weighted Percentages of 
Education Category vs Gum Disease", 
              xlab="Education Category",
              ylab="percentage",
              xlim=c(0,11), 
              ylim = c(0, 100), 
              names.arg=c("<12 grade", "HS grad", "<Uni", "Uni grad"),
              legend=c("Gum Disease", "No Gum Disease"))
text(mp, height, labels = format(height, 4),
     pos = 3.8, cex = .75)
x <- c(49, 34, 17, 0)
y <- c(38, 27, 35, 0)
height <- rbind(x, y)
mp <- barplot(height, beside = TRUE, main ="     Weighted Percentages of Annual House-
hold Income vs Gum Disease", 
              xlab="Annual Household Income Category (in $KUSD)",
              ylab="percentage",
              xlim=c(0,12), 
              ylim = c(0, 100), 
              names.arg=c("[0,35)", "[35-75)", "[75-100)", "100+"),
              legend=c("Gum Disease", "No Gum Disease"))
text(mp, height, labels = format(height, 4),
     pos = 3.8, cex = .75)
??names.arg
# Nel caso generale, i.e., che si usa di
# solito (height MUST be a matrix)
mp <- barplot(height, beside = TRUE)
# Draw the bar values above the bars
text(mp, height, labels = format(height, 4),
     pos = 3, cex = .75)
barplot (height, space = 0, border = NA, ) 
axis (1, at = c (0, 10, 20, 30, 40, 47, 51, 55, 65, 75 ), 
      tck = 1, labels = c (NA, c (1:




