local bold = {}

function bold.getFileExtension()
    local filePath = vim.api.nvim_buf_get_name(0)
    local extension = filePath:match("^.+(%..+)$")
    return extension
end

function bold.isTexFile()
    local extension = bold.getFileExtension()
    return extension == ".tex"
end

function bold.isVisualMode()
  local mode = vim.api.nvim_get_mode().mode
    return mode == 'v' or mode == 'V' or mode == ''  
end

function bold.setListener()
   vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:v",  -- Trigger when entering Visual mode ('v', 'V', or 'CTRL-V')
    callback = isTextSelected,
})
end


 _G.isTextSelected = function()
   repeat
     local start_pos = vim.fn.getpos("'<")  -- Start of visual selection
     local end_pos = vim.fn.getpos("'>")    -- End of visual selection
     local start_line = start_pos[2]
     local start_col = start_pos[3]
     local end_line = end_pos[2]
     local end_col = end_pos[3]
        -- Check if start and end positions differ (meaning text is selected)
        if start_col~=end_col then
            bold.setTextBF(start_line,start_col,end_line,end_col)
        end
        until (not bold.isVisualMode())
    end


function bold.fetchSelectedText(start_line,start_col,end_line,end_col)
  local buffer = vim.api.nvim_buf_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer,start_line,end_line,false)
  local selectedLines = ""
  if start_line == end_line  then
    selectedLines = string.sub(lines,start_col,end_col)
  else
      for i = 1, #lines, 1 do
       if i == 1 then
         selectedLines = string.sub(lines[1],start_line,#lines[1])
           elseif i == (end_line - start_line + 1) then
          selectedLines = selectedLines .. string.sub(lines[i],0,end_col)
            else
                selectedLines = selectedLines .. lines[i]
       end
      end
  end
  return selectedLines
end

function bold.setTextBF(start_line,start_col,end_line,end_col)
    local selectedLines =  bold.fetchSelectedText(start_line,start_col,end_line,end_col)
    local newLines  = "textbf{"..selectedLines.."}"
    local buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buffer, start_line, end_line, false, {newLines})
end

function bold.main()
    if bold.isTexFile() then
        bold.setListener()
    end
end

return bold
