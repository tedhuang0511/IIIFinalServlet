import com.ted.utils.DBConnection;

import java.sql.ResultSet;
import java.sql.SQLException;

public class DBtest {
    public static void main(String[] args) throws SQLException {
        var conn = DBConnection.connectDB();
        var sql = "select * from members where username = ?";
        var pstmt = conn.prepareStatement(
                sql,
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY);
        pstmt.setString(1, "TED");
        var res = pstmt.executeQuery();

        res.next();
        String name = res.getString(2);
        String pw = res.getString("password");
        System.out.println(name + ":" + pw);
    }
}
