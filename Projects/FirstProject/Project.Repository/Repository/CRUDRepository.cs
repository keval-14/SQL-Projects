using Dapper;
using Microsoft.Extensions.Configuration;
using Project.Entities.Request;
using Project.Entities.ViewModels;
using Project.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Repository.Repository
{
    public class CRUDRepository : ICRUDRepository
    {
        private readonly IConfiguration _configuration;
        public string ConnectionString { get; }
        public string providerName { get; }
        public CRUDRepository(IConfiguration configuration)
        {

            _configuration = configuration;
            ConnectionString = configuration.GetConnectionString("practiceDB");
            providerName = "using System.Data.SqlClient";
        }


        public IDbConnection Connection
        {
            get { return new SqlConnection(ConnectionString); }
        }

        #region ListOfEmployee

        public HomeViewModel ListOfEmployee(string sortValue, string sortOreder)
        {

            HomeViewModel employees = new HomeViewModel();

            try
            {
                using (IDbConnection dbConnection = Connection)
                {
                    dbConnection.Open();
                    DynamicParameters param = new DynamicParameters();
                    if (sortValue != null && sortOreder != null)
                    {

                        param.Add("@orderByColumnName", sortValue ?? (object)DBNull.Value);
                        param.Add("@IsSortByAsc", sortOreder ?? (object)DBNull.Value);
                    }
                    employees.AddNewEmployee = dbConnection.Query<AddNewEmployee>("SP_GetAllEmployee", param, commandType: CommandType.StoredProcedure).ToList();

                    dbConnection.Close();

                    return employees;

                }
            }
            catch
            {
                return new HomeViewModel();
            }

        }

        #endregion

        #region AddNewEmp

        public string AddNewEmp(AddNewEmployee newEmp)
        {
            List<AddNewEmployee> empAdded = new List<AddNewEmployee>();
            try
            {
                using (IDbConnection dbConnection = Connection)
                {
                    dbConnection.Open();
                    DynamicParameters param = new DynamicParameters();
                    param.Add("@firstName", newEmp.firstName ?? (object)DBNull.Value);
                    param.Add("@lastName", newEmp.lastName ?? (object)DBNull.Value);
                    param.Add("@gender", newEmp.gender ?? (object)DBNull.Value);
                    param.Add("@dateOfBirth", newEmp.dateOfBirth);
                    param.Add("@departmentId", newEmp.departmentId);
                    param.Add("@salary", newEmp.salary);
                    param.Add("@emailAddress", newEmp.address ?? (object)DBNull.Value);
                    param.Add("@cityId", newEmp.cityId);
                    param.Add("@pincode", newEmp.pinCode);
                    param.Add("@isActive", newEmp.isActive);
                    param.Add("@output", direction: ParameterDirection.Output, size: 150);


                    var text = dbConnection.Query("SP_AddNewEmployee", param, commandType: CommandType.StoredProcedure).ToList();
                    var Responce = param.Get<string>("@output");



                    dbConnection.Close();
                    return Responce;
                }
            }
            catch (Exception ex)
            {
                string errMsg = ex.Message;
                return "Error";
            }

        }

        #endregion

        #region UpdateEmployee

        public int UpdateEmployee(string[] EmployeeData, int empId)
        {
            try
            {
                using (IDbConnection dbConnection = Connection)
                {
                    dbConnection.Open();
                    DynamicParameters param = new DynamicParameters();
                    param.Add("@EmployeeId", empId);
                    param.Add("@FirstName", EmployeeData[0] ?? (object)DBNull.Value);
                    param.Add("@LastName", EmployeeData[1] ?? (object)DBNull.Value);
                    param.Add("@Gender", EmployeeData[2]);
                    param.Add("@DateofBirth", Convert.ToDateTime(EmployeeData[3]));
                    param.Add("@DepartmentId", EmployeeData[4]);
                    param.Add("@Salary", EmployeeData[5]);
                    param.Add("@Address", EmployeeData[6]);
                    param.Add("@CityId", EmployeeData[7]);
                    param.Add("@PinCode", EmployeeData[8]);
                    param.Add("@IsActive", EmployeeData[9]);

                    param.Add("@output", direction: ParameterDirection.Output, size: 150);


                    var text = dbConnection.Query("SP_UpdateEmployee", param, commandType: CommandType.StoredProcedure);
                    var Responce = param.Get<string>("@output");

                    dbConnection.Close();
                    if (Responce == "1")
                    {

                        return 1;
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                string errMsg = ex.Message;
                return 1;
            }


        }
        #endregion

        #region DeleteEmployee
        public string DeleteEmployee(int EmpId)
        {
            try
            {
                using (IDbConnection dbConnection = Connection)
                {
                    dbConnection.Open();
                    DynamicParameters param = new DynamicParameters();
                    param.Add("@EmployeeId", EmpId);
                    param.Add("@output", direction: ParameterDirection.Output, size: 150);

                    var text = dbConnection.Query("SP_DeleteEmployeeById", param, commandType: CommandType.StoredProcedure);
                    var Responce = param.Get<string>("@output");

                    return Responce;
                }
            }
            catch (Exception ex)
            {
                string errMsg = ex.Message;
                return "0";
            }

        }

        #endregion
    }
}
