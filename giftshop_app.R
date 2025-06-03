library(shiny)
library(shinythemes)
library(DT)
library(shinyWidgets)

# Sample Data (Add more items with appropriate subcategories, gender, etc.)
products <- data.frame(
  Name = c("Rose Teddy", "Customized Mug", "LED Frame"),
  Description = c("Elegant teddy made of roses", 
                  "Personalized mug with your message", 
                  "Stylish LED-lit frame for photos"),
  Price = c(25, 15, 35),
  Availability = c("In Stock", "In Stock", "Limited Stock"),
  Gender = c("Women", "Unisex", "Men"),
  Subcategory = c("Accessories", "Accessories", "Bags"),
  Sale = c(TRUE, FALSE, TRUE),
  Location = c("Nairobi", "Mombasa", "Nairobi"),
  Image = c("Rose Teddy.jpg", "Customized Mug.jpg", "LED Frame.jpg"),
  stringsAsFactors = FALSE
)

# UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  tags$head(tags$style(HTML("
    .product-image { width: 100%; height: 220px; object-fit: cover; border-radius: 10px; }
    .card { background: white; border-radius: 10px; padding: 15px; margin-bottom: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
    .price { color: #E91E63; font-weight: bold; font-size: 18px; }
  "))),
  
  navbarPage("Gift Hub", id = "nav",
             
             tabPanel("Home",
                      h2("🎁 Welcome to Gift Hub"),
                      p("Your elegant, modern e-commerce gift shop."),
                      fluidRow(
                        lapply(1:nrow(products), function(i) {
                          column(4, div(class = "card",
                                        img(src = products$Image[i], class = "product-image"),
                                        h4(products$Name[i]),
                                        p(products$Description[i]),
                                        span(class = "price", paste0("$", products$Price[i])),
                                        if (products$Sale[i]) span("🔥 On Sale!", style = "color: red; font-weight: bold;"),
                                        br(),
                                        actionButton(paste0("add_", i), "Add to Cart", icon = icon("cart-plus"))
                          ))
                        })
                      )
             ),
             
             tabPanel("Shop",
                      sidebarLayout(
                        sidebarPanel(
                          pickerInput("gender", "Gender", choices = c("Women", "Men", "Unisex"), selected = c("Women", "Men"), multiple = TRUE),
                          pickerInput("subcategory", "Subcategory", choices = unique(products$Subcategory), selected = unique(products$Subcategory), multiple = TRUE),
                          pickerInput("location", "Location", choices = unique(products$Location), selected = unique(products$Location), multiple = TRUE),
                          checkboxInput("saleOnly", "On Sale Only", FALSE),
                          sliderInput("price_range", "Price Range", min = 0, max = 100, value = c(0, 50))
                        ),
                        mainPanel(
                          DTOutput("shop_table")
                        )
                      )
             ),
             
             tabPanel("Contact",
                      fluidRow(
                        column(6,
                               h3("Need Help?"),
                               textInput("name", "Your Name"),
                               textInput("email", "Email Address"),
                               textAreaInput("message", "Message", "", rows = 4),
                               actionButton("send", "Send", class = "btn-primary")
                        ),
                        column(6,
                               h4("Follow Us"),
                               tags$ul(
                                 tags$li(a("Instagram", href = "#")),
                                 tags$li(a("Facebook", href = "#")),
                                 tags$li(a("Twitter", href = "#"))
                               )
                        )
                      )
             )
  )
)

# Server
server <- function(input, output, session) {
  
  filtered_products <- reactive({
    df <- products[
      products$Price >= input$price_range[1] &
        products$Price <= input$price_range[2] &
        products$Gender %in% input$gender &
        products$Subcategory %in% input$subcategory &
        products$Location %in% input$location, ]
    
    if (input$saleOnly) {
      df <- df[df$Sale == TRUE, ]
    }
    
    return(df)
  })
  
  output$shop_table <- renderDT({
    datatable(filtered_products(), options = list(pageLength = 5))
  })
}

shinyApp(ui, server)
