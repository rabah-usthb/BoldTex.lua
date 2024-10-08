local bold = {}

function bold.setKeyMap(key)
   vim.api.nvim_set_keymap('v', key, ':lua require("Bold").setTextBF()<CR>', { noremap = true, silent = true })  
end

function bold.getFileExtension()
    local filePath = vim.api.nvim_buf_get_name(0)
    local extension = filePath:match("^.+(%..+)$")
    return extension
end

function bold.isTexFile()
    local extension = bold.getFileExtension()
    return extension == ".tex"
end


function bold.fetchSelectedText(start_line,start_col,end_line,end_col)
  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer,start_line-1,end_line,false)
 -- print("Lines: " .. table.concat(lines, "\n"))  -- Use table.concat to join the lines
    
  local selectedLines = {}
  if start_line == end_line  then
    selectedLines[1] = string.sub(lines[1],0,start_col-1) .. " \\textbf{"..string.sub(lines[1],start_col,end_col)..'}' .. string.sub(lines[1],end_col+1,#lines[1])
  else
      for i = 1, #lines, 1 do
       if i == 1 then
         selectedLines[i] = string.sub(lines[1],0,start_col-1) .. " \\textbf{" .. string.sub(lines[1],start_col,#lines[1])
           elseif i == (end_line - start_line + 1) then
          selectedLines[i] = string.sub(lines[i],0,end_col)..'}'.. string.sub(lines[i],end_col+1,#lines[i])
            else
                selectedLines[i] = lines[i]
       end
      end
  end
  return selectedLines
end

function bold.setTextBF()
    local start_pos = vim.fn.getpos("'<")  
    local end_pos = vim.fn.getpos("'>")    
    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3] 
    --print("sLine "..start_line.." sCol "..start_col.." eLine "..end_line.." eCol "..end_col)
    local boldedLines =  bold.fetchSelectedText(start_line,start_col,end_line,end_col)
    --print("String Lines : "..stringLines)
    --local newLines  = "textbf{"..selectedLines.."}"
    --newLines = string.sub(stringLines,0,start_col-1) .. newLines .. string.sub(stringLines,end_col+1,#stringLines)
   -- print("oldNew "..old .. "\n new "..newLines)
    local buffer = vim.api.nvim_get_current_buf()
   vim.api.nvim_buf_set_lines(buffer, start_line-1, end_line, false, boldedLines)
end

function bold.main(key)
   local keyMap =  key or 'f'
    if bold.isTexFile() then
   --     print("is tex file yaya")
        bold.setKeyMap(keyMap)
    end
end

return bold
