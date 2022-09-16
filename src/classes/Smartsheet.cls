/****************************************************************************
    Copyright 2013 Smartsheet, Inc.
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and       
    limitations under the License.             
*****************************************************************************/
public with sharing class Smartsheet {

    /*
    * Represent Index Result object
    */

    public class IndexResultOrgSheets {
        public Integer pageNumber;
        public Integer pageSize;
        public Integer totalCount;
        public Integer totalPages;
        public SheetsHeader[] data;
    }

    /*
    * Represent Sheat Header object
    */
    public class SheetsHeader {
        public Long id;
        public String name;
        public String owner;
        public String ownerId;
    }

    public class Source {
        public Long id;
        public String type;
    }

    public class UpdateRequestRow {
        public Long id;
        public List<UpdateRequest> cells;

    }
    
    public virtual class UpdateRequest{
    }
    
    public class UpdateRequestCell{
        public Long columnId;
        public decimal value;
    }
    
    public class UpdateRequestCell_Dec extends UpdateRequest {
        public Long columnId;
        public decimal value;
    }
    
    public class UpdateRequestCell_Str extends UpdateRequest {
        public Long columnId;
        public string value;
    }
    public class UpdateRequestCell_Dt extends UpdateRequest {
        public Long columnId;
        public Date value;
    }

    /* 
     * Represent Smartsheet Sheet object
     */
    public class Sheet {
        public Long id;
        public String name;
        public String accessLevel;
        public String permalink;
        public List<Column> columns;
        public List<Row> rows;
        public Integer version;
        public String createdAt;
        public String modifiedAt;
        public Source source;
        
        
        /*
         *  getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public String getAccessLevel() {
            return accessLevel;
        }
        public List<Column> getColumns() {
            return columns;
        }
        public void setColumns(List<Column> columns) {
            this.columns = columns;
        }
        public List<Row> getRows() {
            return rows;
        }
        public void setRows(List<Row> rows) {
            this.rows = rows;
        }

    }
    
    /*
     * Represent Smartsheet Row object
     */
    public class Row {
        public Long id;
        public Long sheetId;
        public Long rowNumber;
        public Long siblingId;
        public Long parentId;
        public Boolean expanded;
        public List<Cell> cells;
        public Long version;
        public String createdAt;
        public String modifiedAt;
        
        /*
         * getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        public Long getSheetId() {
            return sheetId;
        }
        public void setSheetId(Long id) {
            this.sheetId = sheetId;
        }
        public Long getRowNumber() {
            return rowNumber;
        }
        public void setRowNumber(Long rowNumber) {
            this.rowNumber = rowNumber;
        }
        public List<Cell> getCells() {
            return cells;
        }
        public void setCells(List<Cell> cells) {
            this.cells = cells;
        }
        public Long getVersion() {
            return version;
        }
    }
    
    /*
     * Represent Smartsheet Column object
     */
    public class Column {
        public Long id;
        public Integer index;
        public String symbol;
        public String title;
        public String type;
        public Boolean primary;
        public List<String> options;
        
        
        /*
         * getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public Integer getIndex() {
            return index;
        }
        public String getTitle() {
            return title;
        }
        public void setTitle(String title) {
            this.title = title;
        }
        public String getType() {
            return type;
        }
        public void setType(String type) {
            this.type = type;
        }
        public Boolean getPrimary() {
            return primary;
        }
    }
    
    /*
     * represent Smartsheet Cell object
     */
    public class Cell {
        public String type;
        public String value;
        public String displayValue;
        public Long columnId;
        public Long rowId;
        public String link;
        public Boolean strict;
        
        
        /*
         * getter/seter are only needed to access from VF page
         */
        public String getType() {
            return type;
        }
        public void setType(String type) {
            this.type = type;
        }
        public String getValue() {
            return value;
        }
        public void setValue(String value) {
            this.value = value;
        }
        public String getDisplayValue() {
            return displayValue;
        }
        public Long getColumnId() {
            return columnId;
        }
        public void setColumnId(Long columnId) {
            this.columnId = columnId;
        }
        public Long getRowId() {
            return rowId;
        }
        public void setRowId(Long rowId) {
            this.rowId = rowId;
        }
        public Boolean getStrict() {
            return strict;
        }
        public void setStrict(Boolean strict) {
            this.strict = strict;
        }
    }
    
    /*
     * represent Smartsheet AccessToken response object
     */
    /* 
    public class AccessToken {
        public String access_token;
        public String token_type;
        public String refresh_token;
        public Integer expires_in;
        
        public String getAccessToken() {
            return access_token;
        }
    }*/
    
    /* 
     * represent json model for Smartsheet Sheet-manupluating method response
     */
    public class SheetResult {
        public String message;
        public Integer resultCode;
        public Sheet result;
        public Long id;
    }
    
    /*
     * represent json model for Smartsheet InserRows method
     */
    /*
    public class InsertRows {
        public Boolean toTop;
        public Boolean toBottom;
        public Long parentId;
        public Long siblingId;
        public List<Row> rows;
        
        public List<Row> getRows() {
            return rows;
        }
    }
    */
    
    public class RowsResult {
        public String message;
        public Integer resultCode;
        public List<Row> result;
    }
    
    /*
    public class RestError {
        public String error;
        public String message;
        public Integer errorCode;
    }
    */


    
}