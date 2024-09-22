# 從 CRAN 安裝 RSelenium
# install.packages("RSelenium")
#1.download the selenium-server-standalone-3.141.59.jar on the selenium website
#2.open cmd in windows to run the jar, it dependes
# the way to use Rselenium: https://rpubs.com/grahamplace/rseleniumonmac

#send below 2 lines to terminal ctrl+alt+Enter
D:
java -Dwebdriver.chrome.driver=D:\chromedriver.exe -Dwebdriver.gecko.driver=D:\geckodriver.exe -jar selenium-server-standalone-3.141.59.jar -port 4445
#####
library(RSelenium)
#First, open the cmd on windows and run the code below (jump the the directory of selenium-server-standalone-3.141.59.jar first)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445,
  browserName = "chrome"
  )

#refresh the website page
remDr$refresh()
#go back to the last page
remDr$goBack()

#If the page is shut down, refresh the page and go back to the last page.

remDr$open() # open the web browser
remDr$navigate("http://140.128.103.17/thuhyint/sendurl_api_v3.jsp?dbid=LDB0100") # go to the URL
remDr$findElement("id", "uid")$sendKeysToElement(list("D05110004")) #input the account name
remDr$findElement("id", "pwd")$sendKeysToElement(list("abc12345")) # input the password
remDr$findElement("xpath", "//img[@alt='登入']")$clickElement() #click the login button


#choose the Modern document
remDr$findElement("xpath", "//label[text() = 'Modern Documents']")$clickElement() 

# click login button
remDr$findElement("id", "actions")$clickElement() 
Sys.sleep(20)

#click the graph "申報數據庫"
remDr$findElement("xpath", "//img[@src='/sypt/image2/1_1_2.gif']")$clickElement() 
Sys.sleep(20)

#click "我已閱讀" agreement of the database
remDr$findElement("xpath", "//img[@src='/assets/ok.png']")$clickElement() 

#######

#clear keywords search
remDr$findElement("id", "kw")$clearElement()

# find out the search column and input the keywords
remDr$findElement("id", "kw")$sendKeysToElement(list("白銀")) 

# click "GO" button
remDr$findElement("xpath", "//a[text()='GO']")$clickElement()

#create a vector for the data of keywords
try <- vector()

# download the data of keywords at page 1.
# The results of searching keywords are listed 35 records at every page. The tag on the page is tr_0 to tr_34
i <- 0
while(i <= 34) {
  tempi  <- remDr$findElement(using = "xpath", paste0(value = "//span[@id='tr_",i,"']"))  #tr_0~34
  try[i+1] <- tempi$getElementText() 
  i <- i+1
}


# obtain the total number of the pages after searching the keywords
page.elem <- remDr$findElement("xpath", "//span[@class='info_t2']")

#define a variable "t" for the total number of pages.  
num <- print(page.elem$getElementText()) 
numm <- as.numeric(num)
t <- ceiling(numm/35)
#floor()



j <- 2 #input the current page +1. For example, when we search the keywords, it will show up the first page of the results. 
#If the page shut down at page 9, just refresh, go back to page 8, input j <- 9 and run the loop again.

while (j <= t){
  
  web.link <- remDr$findElement(using = "xpath", paste0(value = "//a[text()='",j,"']"))
  web.link$clickElement()
  Sys.sleep(30)
  
  i <- 0
  while (i <= 34) {
    tempi  <- remDr$findElement(using = "xpath", paste0(value = "//span[@id='tr_",i,"']"))  #tr_0~34
    try[(i+1)+(j-1)*35] <- tempi$getElementText() 
    i <- i+1
  }
  
  j <- j + 1
}

b <- matrix(try)
write.csv(b, file = 'b.csv')
