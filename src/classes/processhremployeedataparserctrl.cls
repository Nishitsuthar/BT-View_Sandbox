public class processhremployeedataparserctrl {

    public class Data {
        public String ZIP;
        public String BUSINESS_GROUP;
        public String ASSIGNMENT_NUMBER;
        public String JOB_FUNCTION;
        public String LAST_UPDATE_DATE;
        public String FUTURE_EXPENSE_CODE;
        public String SALES_REGION;
        public String EMAIL_ADDRESS;
        public String COUNTRY;
        public String SFDC_STATUS;
        public String JOB;
        public String CREATED_BY;
        public String ORACLE_STATUS;
        public Integer LAST_UPDATED_BY;
        public String INTERCOMPANY_EXPENSE_CODE;
        public String SUPERVISOR;
        public String CREATION_DATE;
        public String LATEST_REJOIN_DATE;
        public String REGION;
        public String EMPLOYEE_TYPE;
        public String ACCOUNT_EXPENSE_CODE;
        public String PROJECT_EXPENSE_CODE;
        public String LOCATION;
        public String DEPT_NAME;
        public String ORACLE_ACTION;
        public String SUPERVISOR_ID;
        public String STATE;
        public String EFFECTIVE_DATE_TO;
        public String LAST_NAME;
        public String PRODUCT_EXPENSE_CODE;
        public String FIRST_NAME;
        public String ADDRESS_STYLE;
        public String MESSAGE;
        public String EFFECTIVE_DATE_FROM;
        public String EMPLOYEE_NUMBER;
        public String GENDER;
        public String HOME_ADDR3;
        public String JOB_GRADE;
        public String HOME_ADDR1;
        public String HOME_ADDR2;
        public String COMP_EXPENSE_CODE;
        public String JOB_TITLE;
        public String DEPT_EXPENSE_CODE;
        public String PRIMARY;
        public Integer LAST_UPDATE_LOGIN;
        public String WORK_PHONE;
        public String SSN;
        public String TALEND_PROCESS_ID;
        public String JOB_AREA;
        public String CITY;
        public String LEDGER;
        public String CONCUR_STATUS;
    }

    public class Processhremployeedataparser {
        public List<Data> data;
    }

    
    public static Processhremployeedataparser parse(String json) {
        return (Processhremployeedataparser) System.JSON.deserialize(json, Processhremployeedataparser.class);
    }
}