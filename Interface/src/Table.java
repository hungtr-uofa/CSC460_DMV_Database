import java.util.Collection;
import java.util.Optional;

public interface Table {
	public static abstract class Field {
		public abstract String getName();
		public abstract String getType();
		public abstract boolean isNullable();
		public abstract boolean isPrimaryKey();
		public abstract Optional<Table> foreignKeyTo();
		public boolean isForeignKey() {
			return foreignKeyTo().isPresent();
		}
	}
	public Collection<Field> getFields();
	public String getName();
}
