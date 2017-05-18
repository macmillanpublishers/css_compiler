# Inputs: 
# html file
# scss file
# final file

# Process:
# Get list of classes is use
# Filter for uniq
# Append scss import for each uniq class (using standard string for path)
# Compile scss

require 'nokogiri'

htmlfile = ARGV[0] # full path and filename for source html file
scssfile = ARGV[1] # full path and filename for skeleton scss file
scsspath = ARGV[2] # path to the component SCSS files
finalcss = ARGV[3] # full path and filename for final compiled CSS file

# Get a list of all classes used in the HTML
def getClasses(arr, html)
  page = Nokogiri::HTML(open(html))
  elements = page.css("*")
  elements.each{ |el| arr << el['class'] }
end

# Based on the list of classes,
# add imports to the corresponding scss module
# for every class in use in the HTML.
def addImports(arr, file, path)
  arr.each do |myclass|
    scssimport = "@import " + path + "_" + myclass + ".scss';"
    File.open(file, "a+") do |output| 
      output.write scssimport
    end
  end
end

# compile the scss
def compileSCSS(scss, css)
  `sass #{scss} #{finalcss}`
end

# PROCESSES

classes = []

getClasses(classes, htmlfile)

# filter the array of classes for unique values only
classes = classes.uniq

addImports(classes, scssfile, scsspath)

compileSCSS(scssfile, finalcss)